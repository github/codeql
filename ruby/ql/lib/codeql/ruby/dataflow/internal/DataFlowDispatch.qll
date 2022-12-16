private import codeql.ruby.AST
private import codeql.ruby.CFG
private import DataFlowPrivate
private import codeql.ruby.typetracking.TypeTracker
private import codeql.ruby.typetracking.TypeTrackerSpecific as TypeTrackerSpecific
private import codeql.ruby.ast.internal.Module
private import FlowSummaryImpl as FlowSummaryImpl
private import FlowSummaryImplSpecific as FlowSummaryImplSpecific
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.SSA

newtype TReturnKind =
  TNormalReturnKind() or
  TBreakReturnKind() or
  TNewReturnKind()

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { call = result.getCall(kind) }

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable.
 */
abstract class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this position. */
  abstract string toString();
}

/**
 * A value returned from a callable using a `return` statement or an expression
 * body, that is, a "normal" return.
 */
class NormalReturnKind extends ReturnKind, TNormalReturnKind {
  override string toString() { result = "return" }
}

/**
 * A value returned from a callable using a `break` statement.
 */
class BreakReturnKind extends ReturnKind, TBreakReturnKind {
  override string toString() { result = "break" }
}

/**
 * A special return kind that is used to represent the value returned
 * from user-defined `new` methods as well as the effect on `self` in
 * `initialize` methods.
 */
class NewReturnKind extends ReturnKind, TNewReturnKind {
  override string toString() { result = "new" }
}

/** A callable defined in library code, identified by a unique string. */
abstract class LibraryCallable extends string {
  bindingset[this]
  LibraryCallable() { any() }

  /** Gets a call to this library callable. */
  Call getACall() { none() }

  /** Same as `getACall()` except this does not depend on the call graph or API graph. */
  Call getACallSimple() { none() }
}

/**
 * A callable. This includes callables from source code, as well as callables
 * defined in library code.
 */
class DataFlowCallable extends TDataFlowCallable {
  /** Gets the underlying source code callable, if any. */
  Callable asCallable() { this = TCfgScope(result) }

  /** Gets the underlying library callable, if any. */
  LibraryCallable asLibraryCallable() { this = TLibraryCallable(result) }

  /** Gets a textual representation of this callable. */
  string toString() { result = [this.asCallable().toString(), this.asLibraryCallable()] }

  /** Gets the location of this callable. */
  Location getLocation() {
    result = this.asCallable().getLocation()
    or
    this instanceof TLibraryCallable and
    result instanceof EmptyLocation
  }
}

/**
 * A call. This includes calls from source code, as well as call(back)s
 * inside library callables with a flow summary.
 */
class DataFlowCall extends TDataFlowCall {
  /** Gets the enclosing callable. */
  DataFlowCallable getEnclosingCallable() { none() }

  /** Gets the underlying source code call, if any. */
  CfgNodes::ExprNodes::CallCfgNode asCall() { none() }

  /** Gets a textual representation of this call. */
  string toString() { none() }

  /** Gets the location of this call. */
  Location getLocation() { none() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * A synthesized call inside a callable with a flow summary.
 *
 * For example, in
 * ```rb
 * ints.each do |i|
 *   puts i
 * end
 * ```
 *
 * there is a call to the block argument inside `each`.
 */
class SummaryCall extends DataFlowCall, TSummaryCall {
  private FlowSummaryImpl::Public::SummarizedCallable c;
  private DataFlow::Node receiver;

  SummaryCall() { this = TSummaryCall(c, receiver) }

  /** Gets the data flow node that this call targets. */
  DataFlow::Node getReceiver() { result = receiver }

  override DataFlowCallable getEnclosingCallable() { result.asLibraryCallable() = c }

  override string toString() { result = "[summary] call to " + receiver + " in " + c }

  override EmptyLocation getLocation() { any() }
}

private class NormalCall extends DataFlowCall, TNormalCall {
  private CfgNodes::ExprNodes::CallCfgNode c;

  NormalCall() { this = TNormalCall(c) }

  override CfgNodes::ExprNodes::CallCfgNode asCall() { result = c }

  override DataFlowCallable getEnclosingCallable() { result = TCfgScope(c.getScope()) }

  override string toString() { result = c.toString() }

  override Location getLocation() { result = c.getLocation() }
}

/** A call for which we want to compute call targets. */
private class RelevantCall extends CfgNodes::ExprNodes::CallCfgNode {
  pragma[nomagic]
  RelevantCall() {
    // Temporarily disable operation resolution (due to bad performance)
    not this.getExpr() instanceof Operation
  }
}

pragma[nomagic]
private predicate methodCall(RelevantCall call, DataFlow::Node receiver, string method) {
  method = call.getExpr().(MethodCall).getMethodName() and
  receiver.asExpr() = call.getReceiver()
}

pragma[nomagic]
private predicate flowsToMethodCallReceiver(
  RelevantCall call, DataFlow::LocalSourceNode sourceNode, string method
) {
  exists(DataFlow::Node receiver |
    methodCall(call, receiver, method) and
    sourceNode.flowsTo(receiver)
  )
}

pragma[nomagic]
private predicate moduleFlowsToMethodCallReceiver(RelevantCall call, Module m, string method) {
  flowsToMethodCallReceiver(call, trackModuleAccess(m), method)
}

private Block yieldCall(RelevantCall call) {
  call.getExpr() instanceof YieldCall and
  exists(BlockParameterNode node |
    node = trackBlock(result) and
    node.getMethod() = call.getExpr().getEnclosingMethod()
  )
}

pragma[nomagic]
private predicate superCall(RelevantCall call, Module cls, string method) {
  call.getExpr() instanceof SuperCall and
  cls = call.getExpr().getEnclosingModule().getModule() and
  method = call.getExpr().getEnclosingMethod().getName()
}

/** Holds if `self` belongs to module `m`. */
pragma[nomagic]
private predicate selfInModule(SelfVariable self, Module m) {
  exists(Scope scope |
    scope = self.getDeclaringScope() and
    m = scope.(ModuleBase).getModule() and
    not scope instanceof Toplevel
  )
}

/** Holds if `self` belongs to method `method` inside module `m`. */
pragma[nomagic]
private predicate selfInMethod(SelfVariable self, MethodBase method, Module m) {
  exists(ModuleBase encl |
    method = self.getDeclaringScope() and
    encl = method.getEnclosingModule() and
    if encl instanceof SingletonClass
    then m = encl.getEnclosingModule().getModule()
    else m = encl.getModule()
  )
}

/** Holds if `self` belongs to the top-level. */
pragma[nomagic]
private predicate selfInToplevel(SelfVariable self, Module m) {
  self.getDeclaringScope() instanceof Toplevel and
  m = TResolved("Object")
}

/**
 * Holds if SSA definition `def` belongs to a variable introduced via pattern
 * matching on type `m`. For example, in
 *
 * ```rb
 * case object
 *   in C => c then c.foo
 * end
 * ```
 *
 * the SSA definition for `c` is introduced by matching on `C`.
 */
private predicate asModulePattern(SsaDefinitionExtNode def, Module m) {
  exists(AsPattern ap |
    m = resolveConstantReadAccess(ap.getPattern()) and
    def.getDefinitionExt().(Ssa::WriteDefinition).getWriteAccess() = ap.getVariableAccess()
  )
}

/**
 * Holds if `read1` and `read2` are adjacent reads of SSA definition `def`,
 * and `read2` is checked to have type `m`. For example, in
 *
 * ```rb
 * case object
 *   when C then object.foo
 * end
 * ```
 *
 * the two reads of `object` are adjacent, and the second is checked to have type `C`.
 */
private predicate hasAdjacentTypeCheckedReads(
  Ssa::Definition def, CfgNodes::ExprCfgNode read1, CfgNodes::ExprCfgNode read2, Module m
) {
  exists(
    CfgNodes::ExprCfgNode pattern, ConditionBlock cb, CfgNodes::ExprNodes::CaseExprCfgNode case
  |
    m = resolveConstantReadAccess(pattern.getExpr()) and
    cb.getLastNode() = pattern and
    cb.controls(read2.getBasicBlock(),
      any(SuccessorTypes::MatchingSuccessor match | match.getValue() = true)) and
    def.hasAdjacentReads(read1, read2) and
    case.getValue() = read1
  |
    pattern = case.getBranch(_).(CfgNodes::ExprNodes::WhenClauseCfgNode).getPattern(_)
    or
    pattern = case.getBranch(_).(CfgNodes::ExprNodes::InClauseCfgNode).getPattern()
  )
}

/** Holds if `new` is a user-defined `self.new` method. */
predicate isUserDefinedNew(SingletonMethod new) {
  exists(Expr object | singletonMethod(new, "new", object) |
    selfInModule(object.(SelfVariableReadAccess).getVariable(), _)
    or
    exists(resolveConstantReadAccess(object))
  )
}

private Callable viableSourceCallableNonInit(RelevantCall call) {
  result = getTarget(call) and
  not call.getExpr() instanceof YieldCall // handled by `lambdaCreation`/`lambdaCall`
}

private Callable viableSourceCallableInit(RelevantCall call) {
  result = getInitializeTarget(call) and
  not isUserDefinedNew(getTarget(call))
}

/** Holds if `call` may resolve to the returned source-code method. */
private Callable viableSourceCallable(RelevantCall call) {
  result = viableSourceCallableNonInit(call) or
  result = viableSourceCallableInit(call)
}

/** Holds if `call` may resolve to the returned summarized library method. */
DataFlowCallable viableLibraryCallable(DataFlowCall call) {
  exists(LibraryCallable callable |
    result = TLibraryCallable(callable) and
    call.asCall().getExpr() = [callable.getACall(), callable.getACallSimple()]
  )
}

/** Holds if there is a call like `receiver.extend(M)`. */
pragma[nomagic]
private predicate extendCall(DataFlow::ExprNode receiver, Module m) {
  exists(DataFlow::CallNode extendCall |
    extendCall.getMethodName() = "extend" and
    exists(DataFlow::LocalSourceNode sourceNode | sourceNode.flowsTo(extendCall.getArgument(_)) |
      selfInModule(sourceNode.(SsaSelfDefinitionNode).getVariable(), m) or
      m = resolveConstantReadAccess(sourceNode.asExpr().getExpr())
    ) and
    receiver = extendCall.getReceiver()
  )
}

/** Holds if there is a call like `M.extend(N)` */
pragma[nomagic]
private predicate extendCallModule(Module m, Module n) {
  exists(DataFlow::LocalSourceNode receiver, DataFlow::ExprNode e |
    receiver.flowsTo(e) and extendCall(e, n)
  |
    selfInModule(receiver.(SsaSelfDefinitionNode).getVariable(), m) or
    m = resolveConstantReadAccess(receiver.asExpr().getExpr())
  )
}

/**
 * Gets a method available in module `m`, or in one of `m`'s transitive
 * sub classes when `exact = false`.
 */
pragma[nomagic]
private Method lookupMethod(Module m, string name, boolean exact) {
  result = lookupMethod(m, name) and
  exact in [false, true]
  or
  result = lookupMethodInSubClasses(m, name) and
  exact = false
}

cached
private module Cached {
  cached
  newtype TDataFlowCallable =
    TCfgScope(CfgScope scope) or
    TLibraryCallable(LibraryCallable callable)

  cached
  newtype TDataFlowCall =
    TNormalCall(CfgNodes::ExprNodes::CallCfgNode c) or
    TSummaryCall(FlowSummaryImpl::Public::SummarizedCallable c, DataFlow::Node receiver) {
      FlowSummaryImpl::Private::summaryCallbackRange(c, receiver)
    }

  /**
   * Gets the relevant `initialize` method for the `new` call, if any.
   */
  cached
  Method getInitializeTarget(RelevantCall new) {
    exists(Module m |
      moduleFlowsToMethodCallReceiver(new, m, "new") and
      result = lookupMethod(m, "initialize")
    )
  }

  cached
  CfgScope getTarget(RelevantCall call) {
    result = getTargetInstance(call, _)
    or
    result = getTargetSingleton(call, _)
    or
    exists(Module cls, string method |
      superCall(call, cls, method) and
      result = lookupMethod(cls.getAnImmediateAncestor(), method)
    )
    or
    result = yieldCall(call)
  }

  /** Gets a viable run-time target for the call `call`. */
  cached
  DataFlowCallable viableCallable(DataFlowCall call) {
    result.asCallable() = viableSourceCallable(call.asCall())
    or
    result = viableLibraryCallable(call)
  }

  cached
  newtype TArgumentPosition =
    TSelfArgumentPosition() or
    TBlockArgumentPosition() or
    TPositionalArgumentPosition(int pos) {
      exists(Call c | exists(c.getArgument(pos)))
      or
      FlowSummaryImplSpecific::ParsePositions::isParsedParameterPosition(_, pos)
    } or
    TKeywordArgumentPosition(string name) {
      name = any(KeywordParameter kp).getName()
      or
      exists(any(Call c).getKeywordArgument(name))
      or
      FlowSummaryImplSpecific::ParsePositions::isParsedKeywordParameterPosition(_, name)
    } or
    THashSplatArgumentPosition() or
    TSplatAllArgumentPosition() or
    TAnyArgumentPosition() or
    TAnyKeywordArgumentPosition()

  cached
  newtype TParameterPosition =
    TSelfParameterPosition() or
    TBlockParameterPosition() or
    TPositionalParameterPosition(int pos) {
      pos = any(Parameter p).getPosition()
      or
      FlowSummaryImplSpecific::ParsePositions::isParsedArgumentPosition(_, pos)
    } or
    TPositionalParameterLowerBoundPosition(int pos) {
      FlowSummaryImplSpecific::ParsePositions::isParsedArgumentLowerBoundPosition(_, pos)
    } or
    TKeywordParameterPosition(string name) {
      name = any(KeywordParameter kp).getName()
      or
      FlowSummaryImplSpecific::ParsePositions::isParsedKeywordArgumentPosition(_, name)
    } or
    THashSplatParameterPosition() or
    TSplatAllParameterPosition() or
    TAnyParameterPosition() or
    TAnyKeywordParameterPosition()
}

import Cached

pragma[nomagic]
private DataFlow::LocalSourceNode trackModuleAccess(Module m, TypeTracker t) {
  t.start() and m = resolveConstantReadAccess(result.asExpr().getExpr())
  or
  exists(TypeTracker t2, StepSummary summary |
    result = trackModuleAccessRec(m, t2, summary) and t = t2.append(summary)
  )
}

/**
 * We exclude steps into `self` parameters, and instead rely on the type of the
 * enclosing module.
 */
pragma[nomagic]
private DataFlow::LocalSourceNode trackModuleAccessRec(Module m, TypeTracker t, StepSummary summary) {
  StepSummary::step(trackModuleAccess(m, t), result, summary) and
  not result instanceof SelfParameterNode
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackModuleAccess(Module m) {
  result = trackModuleAccess(m, TypeTracker::end())
}

pragma[nomagic]
private predicate hasUserDefinedNew(Module m) {
  exists(DataFlow::MethodNode method |
    // not `getAnAncestor` because singleton methods cannot be included
    singletonMethodOnModule(method.asCallableAstNode(), "new", m.getSuperClass*()) and
    not method.getSelfParameter().getAMethodCall("allocate").flowsTo(method.getAReturningNode())
  )
}

/** Holds if `n` is an instance of type `tp`. */
private predicate isInstance(DataFlow::Node n, Module tp, boolean exact) {
  n.asExpr().getExpr() instanceof NilLiteral and
  tp = TResolved("NilClass") and
  exact = true
  or
  n.asExpr().getExpr().(BooleanLiteral).isFalse() and
  tp = TResolved("FalseClass") and
  exact = true
  or
  n.asExpr().getExpr().(BooleanLiteral).isTrue() and
  tp = TResolved("TrueClass") and
  exact = true
  or
  n.asExpr().getExpr() instanceof IntegerLiteral and
  tp = TResolved("Integer") and
  exact = true
  or
  n.asExpr().getExpr() instanceof FloatLiteral and
  tp = TResolved("Float") and
  exact = true
  or
  n.asExpr().getExpr() instanceof RationalLiteral and
  tp = TResolved("Rational") and
  exact = true
  or
  n.asExpr().getExpr() instanceof ComplexLiteral and
  tp = TResolved("Complex") and
  exact = true
  or
  n.asExpr().getExpr() instanceof StringlikeLiteral and
  tp = TResolved("String") and
  exact = true
  or
  n.asExpr() instanceof CfgNodes::ExprNodes::ArrayLiteralCfgNode and
  tp = TResolved("Array") and
  exact = true
  or
  n.asExpr() instanceof CfgNodes::ExprNodes::HashLiteralCfgNode and
  tp = TResolved("Hash") and
  exact = true
  or
  n.asExpr().getExpr() instanceof MethodBase and
  tp = TResolved("Symbol") and
  exact = true
  or
  n.asParameter() instanceof BlockParameter and
  tp = TResolved("Proc") and
  exact = true
  or
  n.asExpr().getExpr() instanceof Lambda and
  tp = TResolved("Proc") and
  exact = true
  or
  exists(RelevantCall call, DataFlow::LocalSourceNode sourceNode |
    flowsToMethodCallReceiver(call, sourceNode, "new") and
    n.asExpr() = call and
    // `tp` should not have a user-defined `self.new` method
    not hasUserDefinedNew(tp)
  |
    // `C.new`
    sourceNode = trackModuleAccess(tp) and
    exact = true
    or
    // `self.new` inside a module
    selfInModule(sourceNode.(SsaSelfDefinitionNode).getVariable(), tp) and
    exact = true
    or
    // `self.new` inside a singleton method
    exists(MethodBase caller |
      selfInMethod(sourceNode.(SsaSelfDefinitionNode).getVariable(), caller, tp) and
      singletonMethod(caller, _, _) and
      exact = false
    )
  )
  or
  // `self` reference in method or top-level (but not in module or singleton method,
  // where instance methods cannot be called; only singleton methods)
  n =
    any(SsaSelfDefinitionNode self |
      exists(MethodBase m |
        selfInMethod(self.getVariable(), m, tp) and
        not m instanceof SingletonMethod and
        if m.getEnclosingModule() instanceof Toplevel then exact = true else exact = false
      )
      or
      selfInToplevel(self.getVariable(), tp) and
      exact = true
    )
  or
  // `in C => c then c.foo`
  asModulePattern(n, tp) and
  exact = false
  or
  // `case object when C then object.foo`
  hasAdjacentTypeCheckedReads(_, _, n.asExpr(), tp) and
  exact = false
}

pragma[nomagic]
private DataFlow::Node trackInstance(Module tp, boolean exact, TypeTracker t) {
  t.start() and
  (
    isInstance(result, tp, exact)
    or
    exists(Module m |
      (if m.isClass() then tp = TResolved("Class") else tp = TResolved("Module")) and
      exact = true
    |
      // needed for e.g. `C.new`
      m = resolveConstantReadAccess(result.asExpr().getExpr())
      or
      // needed for e.g. `self.include`
      selfInModule(result.(SsaSelfDefinitionNode).getVariable(), m)
      or
      // needed for e.g. `self.puts`
      selfInMethod(result.(SsaSelfDefinitionNode).getVariable(), any(SingletonMethod sm), m)
    )
  )
  or
  exists(TypeTracker t2, StepSummary summary |
    result = trackInstanceRec(tp, t2, exact, summary) and t = t2.append(summary)
  )
}

private predicate localFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, StepSummary summary) {
  localFlowStepTypeTracker(nodeFrom, nodeTo) and
  summary.toString() = "level"
}

pragma[nomagic]
private predicate hasAdjacentTypeCheckedReads(DataFlow::Node node) {
  hasAdjacentTypeCheckedReads(_, _, node.asExpr(), _)
}

/**
 * We exclude steps into `self` parameters and type checked variables. For those,
 * we instead rely on the type of the enclosing module resp. the type being checked
 * against, and apply an open-world assumption when determining possible dispatch
 * targets.
 */
pragma[nomagic]
private DataFlow::Node trackInstanceRec(Module tp, TypeTracker t, boolean exact, StepSummary summary) {
  exists(DataFlow::Node mid | mid = trackInstance(tp, exact, t) |
    StepSummary::smallstep(mid, result, summary) and
    not result instanceof SelfParameterNode
    or
    localFlowStep(mid, result, summary) and
    not hasAdjacentTypeCheckedReads(result)
  )
}

pragma[nomagic]
private DataFlow::Node trackInstance(Module tp, boolean exact) {
  result = trackInstance(tp, exact, TypeTracker::end())
}

pragma[nomagic]
private Method lookupInstanceMethodCall(RelevantCall call, string method, boolean exact) {
  exists(Module tp, DataFlow::Node receiver |
    methodCall(call, pragma[only_bind_into](receiver), pragma[only_bind_into](method)) and
    receiver = trackInstance(tp, exact) and
    result = lookupMethod(tp, pragma[only_bind_into](method), exact)
  )
}

pragma[nomagic]
private predicate isToplevelMethodInFile(Method m, File f) {
  m.getEnclosingModule() instanceof Toplevel and
  f = m.getFile()
}

pragma[nomagic]
private CfgScope getTargetInstance(RelevantCall call, string method) {
  exists(boolean exact |
    result = lookupInstanceMethodCall(call, method, exact) and
    (
      if result.(Method).isPrivate()
      then
        call.getReceiver().getExpr() instanceof SelfVariableAccess and
        // For now, we restrict the scope of top-level declarations to their file.
        // This may remove some plausible targets, but also removes a lot of
        // implausible targets
        (
          isToplevelMethodInFile(result, call.getFile()) or
          not isToplevelMethodInFile(result, _)
        )
      else any()
    ) and
    if result.(Method).isProtected()
    then result = lookupMethod(call.getExpr().getEnclosingModule().getModule(), method, exact)
    else any()
  )
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackBlock(Block block, TypeTracker t) {
  t.start() and result.asExpr().getExpr() = block
  or
  exists(TypeTracker t2, StepSummary summary |
    result = trackBlockRec(block, t2, summary) and t = t2.append(summary)
  )
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackBlockRec(Block block, TypeTracker t, StepSummary summary) {
  StepSummary::step(trackBlock(block, t), result, summary)
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackBlock(Block block) {
  result = trackBlock(block, TypeTracker::end())
}

/** Holds if `m` is a singleton method named `name`, defined on `object. */
private predicate singletonMethod(MethodBase m, string name, Expr object) {
  name = m.getName() and
  (
    object = m.(SingletonMethod).getObject()
    or
    m = any(SingletonClass cls | object = cls.getValue()).getAMethod().(Method)
  )
}

pragma[nomagic]
private predicate flowsToSingletonMethodObject(
  DataFlow::LocalSourceNode nodeFrom, MethodBase m, string name
) {
  exists(DataFlow::Node nodeTo |
    nodeFrom.flowsTo(nodeTo) and
    singletonMethod(m, name, nodeTo.asExpr().getExpr())
  )
}

/**
 * Holds if `method` is a singleton method named `name`, defined on module
 * `m`:
 *
 * ```rb
 * class C
 *   def self.m1; end # included
 *
 *   class << self
 *     def m2; end # included
 *   end
 * end
 *
 * def C.m3; end # included
 *
 * c_alias = C
 * def c_alias.m4; end # included
 *
 * c = C.new
 * def c.m5; end # not included
 *
 * class << c
 *   def m6; end # not included
 * end
 *
 * module M
 *   def instance; end # included in `N` via `extend` call below
 * end
 * N.extend(M)
 * N.instance
 * ```
 */
pragma[nomagic]
private predicate singletonMethodOnModule(MethodBase method, string name, Module m) {
  exists(Expr object |
    singletonMethod(method, name, object) and
    selfInModule(object.(SelfVariableReadAccess).getVariable(), m)
  )
  or
  exists(DataFlow::LocalSourceNode sourceNode |
    m = resolveConstantReadAccess(sourceNode.asExpr().getExpr()) and
    flowsToSingletonMethodObject(sourceNode, method, name)
  )
  or
  exists(Module other |
    extendCallModule(m, other) and
    method = lookupMethod(other, name)
  )
}

pragma[nomagic]
private MethodBase lookupSingletonMethodDirect(Module m, string name) {
  singletonMethodOnModule(result, name, m)
  or
  exists(DataFlow::LocalSourceNode sourceNode |
    sourceNode = trackModuleAccess(m) and
    not m = resolveConstantReadAccess(sourceNode.asExpr().getExpr()) and
    flowsToSingletonMethodObject(sourceNode, result, name)
  )
}

/**
 * Holds if `method` is a singleton method named `name`, defined on module
 * `m`, or any transitive base class of `m`.
 */
pragma[nomagic]
private MethodBase lookupSingletonMethod(Module m, string name) {
  result = lookupSingletonMethodDirect(m, name)
  or
  // cannot use `lookupSingletonMethodDirect` because it would introduce
  // negative recursion
  not singletonMethodOnModule(_, name, m) and
  result = lookupSingletonMethod(m.getSuperClass(), name) // not `getAnImmediateAncestor` because singleton methods cannot be included
}

pragma[nomagic]
private MethodBase lookupSingletonMethodInSubClasses(Module m, string name) {
  // Singleton methods declared in a block in the top-level may spuriously end up being seen as singleton
  // methods on Object, if the block is actually evaluated in the context of another class.
  // The 'self' inside such a singleton method could then be any class, leading to self-calls
  // being resolved to arbitrary singleton methods.
  // To remedy this, we do not allow following super-classes all the way to Object.
  not m = TResolved("Object") and
  exists(Module sub |
    sub.getSuperClass() = m // not `getAnImmediateAncestor` because singleton methods cannot be included
  |
    result = lookupSingletonMethodDirect(sub, name) or
    result = lookupSingletonMethodInSubClasses(sub, name)
  )
}

pragma[nomagic]
private MethodBase lookupSingletonMethod(Module m, string name, boolean exact) {
  result = lookupSingletonMethod(m, name) and
  exact in [false, true]
  or
  result = lookupSingletonMethodInSubClasses(m, name) and
  exact = false
}

/**
 * Holds if `method` is a singleton method named `name`, defined on expression
 * `object`, where `object` is not likely to resolve to a module:
 *
 * ```rb
 * class C
 *   def self.m1; end # not included
 *
 *   class << self
 *     def m2; end # not included
 *   end
 * end
 *
 * def C.m3; end # not included
 *
 * c_alias = C
 * def c_alias.m4; end # included (due to negative recursion limitation)
 *
 * c = C.new
 * def c.m5; end # included
 *
 * class << c
 *   def m6; end # included
 * end
 *
 * module M
 *   def instance; end # included in `c` via `extend` call below
 * end
 * c.extend(M)
 * ```
 */
pragma[nomagic]
predicate singletonMethodOnInstance(MethodBase method, string name, Expr object) {
  singletonMethod(method, name, object) and
  not selfInModule(object.(SelfVariableReadAccess).getVariable(), _) and
  // cannot use `trackModuleAccess` because of negative recursion
  not exists(resolveConstantReadAccess(object))
  or
  exists(DataFlow::ExprNode receiver, Module other |
    extendCall(receiver, other) and
    object = receiver.getExprNode().getExpr() and
    method = lookupMethod(other, name)
  )
}

/**
 * Holds if there is reverse flow from `nodeFrom` to `nodeTo` via a parameter.
 *
 * This is only used for tracking singleton methods, where we want to be able
 * to handle cases like
 *
 * ```rb
 * def add_singleton x
 *   def x.foo; end
 * end
 *
 * y = add_singleton C.new
 * y.foo
 * ```
 *
 * and
 *
 * ```rb
 * class C
 *   def add_singleton_to_self
 *     def self.foo; end
 *   end
 * end
 *
 * y = C.new
 * y.add_singleton_to_self
 * y.foo
 * ```
 */
pragma[nomagic]
private predicate paramReturnFlow(
  DataFlow::Node nodeFrom, DataFlow::PostUpdateNode nodeTo, StepSummary summary
) {
  exists(RelevantCall call, DataFlow::Node arg, DataFlow::ParameterNode p, Expr nodeFromPreExpr |
    TypeTrackerSpecific::callStep(call, arg, p) and
    nodeTo.getPreUpdateNode() = arg and
    summary.toString() = "return" and
    (
      nodeFromPreExpr = nodeFrom.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr().getExpr()
      or
      nodeFromPreExpr = nodeFrom.asExpr().getExpr() and
      singletonMethodOnInstance(_, _, nodeFromPreExpr)
    )
  |
    nodeFromPreExpr = p.getParameter().(NamedParameter).getVariable().getAnAccess()
    or
    nodeFromPreExpr = p.(SelfParameterNode).getSelfVariable().getAnAccess()
  )
}

pragma[nomagic]
private DataFlow::Node trackSingletonMethodOnInstance(MethodBase method, string name, TypeTracker t) {
  t.start() and
  singletonMethodOnInstance(method, name, result.asExpr().getExpr())
  or
  exists(TypeTracker t2, StepSummary summary |
    result = trackSingletonMethodOnInstanceRec(method, name, t2, summary) and
    t = t2.append(summary) and
    // Stop flow at redefinitions.
    //
    // Example:
    // ```rb
    // def x.foo; end
    // def x.foo; end
    // x.foo # <- we want to resolve this call to the second definition only
    // ```
    not singletonMethodOnInstance(_, name, result.asExpr().getExpr())
  )
}

pragma[nomagic]
private DataFlow::Node trackSingletonMethodOnInstanceRec(
  MethodBase method, string name, TypeTracker t, StepSummary summary
) {
  exists(DataFlow::Node mid | mid = trackSingletonMethodOnInstance(method, name, t) |
    StepSummary::smallstep(mid, result, summary)
    or
    paramReturnFlow(mid, result, summary)
    or
    localFlowStep(mid, result, summary)
  )
}

pragma[nomagic]
private DataFlow::Node trackSingletonMethodOnInstance(MethodBase method, string name) {
  result = trackSingletonMethodOnInstance(method, name, TypeTracker::end())
}

/** Holds if a `self` access may be the receiver of `call` directly inside module `m`. */
pragma[nomagic]
private predicate selfInModuleFlowsToMethodCallReceiver(RelevantCall call, Module m, string method) {
  exists(SsaSelfDefinitionNode self |
    flowsToMethodCallReceiver(call, self, method) and
    selfInModule(self.getVariable(), m)
  )
}

/**
 * Holds if a `self` access may be the receiver of `call` inside some singleton method, where
 * that method belongs to `m` or one of `m`'s transitive super classes.
 */
pragma[nomagic]
private predicate selfInSingletonMethodFlowsToMethodCallReceiver(
  RelevantCall call, Module m, string method
) {
  exists(SsaSelfDefinitionNode self, MethodBase caller |
    flowsToMethodCallReceiver(call, self, method) and
    selfInMethod(self.getVariable(), caller, m) and
    singletonMethod(caller, _, _)
  )
}

pragma[nomagic]
private CfgScope getTargetSingleton(RelevantCall call, string method) {
  // singleton method defined on an instance, e.g.
  // ```rb
  // c = C.new
  // def c.singleton; end # <- result
  // c.singleton          # <- call
  // ```
  // or an `extend`ed instance, e.g.
  // ```rb
  // c = C.new
  // module M
  //   def instance; end  # <- result
  // end
  // c.extend M
  // c.instance # <- call
  // ```
  exists(DataFlow::Node receiver |
    methodCall(call, receiver, method) and
    receiver = trackSingletonMethodOnInstance(result, method)
  )
  or
  // singleton method defined on a module
  // or an `extend`ed module, e.g.
  // ```rb
  // module M
  //   def instance; end  # <- result
  // end
  // M.extend(M)
  // M.instance           # <- call
  // ```
  exists(Module m, boolean exact | result = lookupSingletonMethod(m, method, exact) |
    // ```rb
    // def C.singleton; end # <- result
    // C.singleton          # <- call
    // ```
    moduleFlowsToMethodCallReceiver(call, m, method) and
    exact = true
    or
    // ```rb
    // class C
    //   def self.singleton; end # <- result
    //   self.singleton          # <- call
    // end
    // ```
    selfInModuleFlowsToMethodCallReceiver(call, m, method) and
    exact = true
    or
    // ```rb
    // class C
    //   def self.singleton; end # <- result
    //   def self.other
    //     self.singleton        # <- call
    //   end
    // end
    // ```
    selfInSingletonMethodFlowsToMethodCallReceiver(call, m, method) and
    exact = false
  )
}

/**
 * Holds if `ctx` targets `encl`, which is the enclosing callable of `call`, the receiver
 * of `call` is a parameter access, where the corresponding argument of `ctx` is `arg`.
 *
 * `name` is the name of the method being called by `call`, `source` is a
 * `LocalSourceNode` that flows to `arg`, and `paramDef` is the SSA definition for the
 * parameter that is the receiver of `call`.
 */
pragma[nomagic]
private predicate argMustFlowToReceiver(
  RelevantCall ctx, DataFlow::LocalSourceNode source, DataFlow::Node arg,
  SsaDefinitionExtNode paramDef, RelevantCall call, Callable encl, string name
) {
  exists(ParameterNodeImpl p, ParameterPosition ppos, ArgumentPosition apos |
    // the receiver of `call` references `p`
    exists(DataFlow::Node receiver |
      LocalFlow::localFlowSsaParamInput(p, paramDef) and
      methodCall(pragma[only_bind_into](call), pragma[only_bind_into](receiver),
        pragma[only_bind_into](name)) and
      receiver.asExpr() = paramDef.getDefinitionExt().(Ssa::Definition).getARead()
    ) and
    // `p` is a parameter of `encl`,
    encl = call.getScope() and
    p.isParameterOf(TCfgScope(encl), ppos) and
    // `arg` is the argument for `p` in the call `ctx`
    parameterMatch(ppos, apos) and
    source.flowsTo(arg)
  |
    encl = viableSourceCallableNonInit(ctx) and
    arg.(ArgumentNode).sourceArgumentOf(ctx, apos)
    or
    encl = viableSourceCallableInit(ctx) and
    if apos.isSelf()
    then
      // when we are targeting an initializer, the type of `self` inside the
      // initializer will be the type of the `new` call itself, not the receiver
      // of the `new` call
      arg.asExpr() = ctx
    else arg.(ArgumentNode).sourceArgumentOf(ctx, apos)
  )
}

/**
 * Holds if `ctx` targets `encl`, which is the enclosing callable of `new`, and
 * the receiver of `new` is a parameter access, where the corresponding argument
 * `arg` of `ctx` has type `tp`.
 *
 * `new` calls the object creation `new` method.
 */
pragma[nomagic]
private predicate mayBenefitFromCallContextInitialize(
  RelevantCall ctx, RelevantCall new, DataFlow::Node arg, Callable encl, Module tp, string name
) {
  exists(DataFlow::LocalSourceNode source |
    argMustFlowToReceiver(ctx, pragma[only_bind_into](source), arg, _, new, encl, "new") and
    source = trackModuleAccess(tp) and
    name = "initialize" and
    exists(lookupMethod(tp, name))
  )
}

/**
 * Holds if `ctx` targets `encl`, which is the enclosing callable of `call`, and
 * the receiver of `call` is a parameter access, where the corresponding argument
 * `arg` of `ctx` has type `tp`.
 *
 * `name` is the name of the method being called by `call`, and `exact` is pertaining
 * to the type of the argument.
 */
pragma[nomagic]
private predicate mayBenefitFromCallContextInstance(
  RelevantCall ctx, RelevantCall call, DataFlow::Node arg, Callable encl, Module tp, boolean exact,
  string name
) {
  exists(DataFlow::LocalSourceNode source |
    argMustFlowToReceiver(ctx, pragma[only_bind_into](source), arg, _, call, encl,
      pragma[only_bind_into](name)) and
    source = trackInstance(tp, exact) and
    exists(lookupMethod(tp, pragma[only_bind_into](name)))
  )
}

/**
 * Holds if `ctx` targets `encl`, which is the enclosing callable of `call`, and
 * the receiver of `call` is a parameter access, where the corresponding argument
 * `arg` of `ctx` is a module access targeting a module of type `tp`.
 *
 * `name` is the name of the method being called by `call`, and `exact` is pertaining
 * to the type of the argument.
 */
pragma[nomagic]
private predicate mayBenefitFromCallContextSingleton(
  RelevantCall ctx, RelevantCall call, DataFlow::Node arg, Callable encl, Module tp, boolean exact,
  string name
) {
  exists(DataFlow::LocalSourceNode source |
    argMustFlowToReceiver(ctx, pragma[only_bind_into](source), pragma[only_bind_into](arg), _, call,
      encl, pragma[only_bind_into](name)) and
    exists(lookupSingletonMethod(tp, pragma[only_bind_into](name), exact))
  |
    source = trackModuleAccess(tp) and
    exact = true
    or
    exists(SelfVariable self | arg.asExpr().getExpr() = self.getAnAccess() |
      selfInModule(self, tp) and
      exact = true
      or
      exists(MethodBase caller |
        selfInMethod(self, caller, tp) and
        singletonMethod(caller, _, _) and
        exact = false
      )
    )
  )
}

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context. This is the case if the
 * receiver accesses a parameter of the enclosing callable `c` (including
 * the implicit `self` parameter).
 */
predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable c) {
  mayBenefitFromCallContextInitialize(_, call.asCall(), _, c.asCallable(), _, _)
  or
  mayBenefitFromCallContextInstance(_, call.asCall(), _, c.asCallable(), _, _, _)
  or
  mayBenefitFromCallContextSingleton(_, call.asCall(), _, c.asCallable(), _, _, _)
}

/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
pragma[nomagic]
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
  mayBenefitFromCallContext(call, _) and
  (
    // `ctx` can provide a potentially better type bound
    exists(RelevantCall call0, Callable res |
      call0 = call.asCall() and
      res = result.asCallable() and
      exists(Module m, string name |
        mayBenefitFromCallContextInitialize(ctx.asCall(), pragma[only_bind_into](call0), _, _,
          pragma[only_bind_into](m), pragma[only_bind_into](name)) and
        res = getInitializeTarget(call0) and
        res = lookupMethod(m, name)
        or
        exists(boolean exact |
          mayBenefitFromCallContextInstance(ctx.asCall(), pragma[only_bind_into](call0), _, _,
            pragma[only_bind_into](m), pragma[only_bind_into](exact), pragma[only_bind_into](name)) and
          res = getTargetInstance(call0, name) and
          res = lookupMethod(m, name, exact)
          or
          mayBenefitFromCallContextSingleton(ctx.asCall(), pragma[only_bind_into](call0), _, _,
            pragma[only_bind_into](m), pragma[only_bind_into](exact), pragma[only_bind_into](name)) and
          res = getTargetSingleton(call0, name) and
          res = lookupSingletonMethod(m, name, exact)
        )
      )
    )
    or
    // `ctx` cannot provide a type bound, and the receiver of the call is `self`;
    // in this case, still apply an open-world assumption
    exists(
      RelevantCall call0, RelevantCall ctx0, DataFlow::Node arg, SsaSelfDefinitionNode self,
      string name
    |
      call0 = call.asCall() and
      ctx0 = ctx.asCall() and
      argMustFlowToReceiver(ctx0, _, arg, self, call0, _, name) and
      not mayBenefitFromCallContextInitialize(ctx0, call0, arg, _, _, _) and
      not mayBenefitFromCallContextInstance(ctx0, call0, arg, _, _, _, name) and
      not mayBenefitFromCallContextSingleton(ctx0, call0, arg, _, _, _, name) and
      result.asCallable() = viableSourceCallable(call0)
    )
    or
    // library calls should always be able to resolve
    argMustFlowToReceiver(ctx.asCall(), _, _, _, call.asCall(), _, _) and
    result = viableLibraryCallable(call)
  )
}

predicate exprNodeReturnedFrom = exprNodeReturnedFromCached/2;

/** A parameter position. */
class ParameterPosition extends TParameterPosition {
  /** Holds if this position represents a `self` parameter. */
  predicate isSelf() { this = TSelfParameterPosition() }

  /** Holds if this position represents a block parameter. */
  predicate isBlock() { this = TBlockParameterPosition() }

  /** Holds if this position represents a positional parameter at position `pos`. */
  predicate isPositional(int pos) { this = TPositionalParameterPosition(pos) }

  /** Holds if this position represents any positional parameter starting from position `pos`. */
  predicate isPositionalLowerBound(int pos) { this = TPositionalParameterLowerBoundPosition(pos) }

  /** Holds if this position represents a keyword parameter named `name`. */
  predicate isKeyword(string name) { this = TKeywordParameterPosition(name) }

  /** Holds if this position represents a hash-splat parameter. */
  predicate isHashSplat() { this = THashSplatParameterPosition() }

  predicate isSplatAll() { this = TSplatAllParameterPosition() }

  /**
   * Holds if this position represents any parameter, except `self` parameters. This
   * includes both positional, named, and block parameters.
   */
  predicate isAny() { this = TAnyParameterPosition() }

  /** Holds if this position represents any positional parameter. */
  predicate isAnyNamed() { this = TAnyKeywordParameterPosition() }

  /** Gets a textual representation of this position. */
  string toString() {
    this.isSelf() and result = "self"
    or
    this.isBlock() and result = "block"
    or
    exists(int pos | this.isPositional(pos) and result = "position " + pos)
    or
    exists(int pos | this.isPositionalLowerBound(pos) and result = "position " + pos + "..")
    or
    exists(string name | this.isKeyword(name) and result = "keyword " + name)
    or
    this.isHashSplat() and result = "**"
    or
    this.isSplatAll() and result = "*"
    or
    this.isAny() and result = "any"
    or
    this.isAnyNamed() and result = "any-named"
  }
}

/** An argument position. */
class ArgumentPosition extends TArgumentPosition {
  /** Holds if this position represents a `self` argument. */
  predicate isSelf() { this = TSelfArgumentPosition() }

  /** Holds if this position represents a block argument. */
  predicate isBlock() { this = TBlockArgumentPosition() }

  /** Holds if this position represents a positional argument at position `pos`. */
  predicate isPositional(int pos) { this = TPositionalArgumentPosition(pos) }

  /** Holds if this position represents a keyword argument named `name`. */
  predicate isKeyword(string name) { this = TKeywordArgumentPosition(name) }

  /**
   * Holds if this position represents any argument, except `self` arguments. This
   * includes both positional, named, and block arguments.
   */
  predicate isAny() { this = TAnyArgumentPosition() }

  /** Holds if this position represents any positional parameter. */
  predicate isAnyNamed() { this = TAnyKeywordArgumentPosition() }

  /**
   * Holds if this position represents a synthesized argument containing all keyword
   * arguments wrapped in a hash.
   */
  predicate isHashSplat() { this = THashSplatArgumentPosition() }

  predicate isSplatAll() { this = TSplatAllArgumentPosition() }

  /** Gets a textual representation of this position. */
  string toString() {
    this.isSelf() and result = "self"
    or
    this.isBlock() and result = "block"
    or
    exists(int pos | this.isPositional(pos) and result = "position " + pos)
    or
    exists(string name | this.isKeyword(name) and result = "keyword " + name)
    or
    this.isAny() and result = "any"
    or
    this.isAnyNamed() and result = "any-named"
    or
    this.isHashSplat() and result = "**"
    or
    this.isSplatAll() and result = "*"
  }
}

pragma[nomagic]
private predicate parameterPositionIsNotSelf(ParameterPosition ppos) { not ppos.isSelf() }

pragma[nomagic]
private predicate argumentPositionIsNotSelf(ArgumentPosition apos) { not apos.isSelf() }

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
pragma[nomagic]
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  ppos.isSelf() and apos.isSelf()
  or
  ppos.isBlock() and apos.isBlock()
  or
  exists(int pos | ppos.isPositional(pos) and apos.isPositional(pos))
  or
  exists(int pos1, int pos2 |
    ppos.isPositionalLowerBound(pos1) and apos.isPositional(pos2) and pos2 >= pos1
  )
  or
  exists(string name | ppos.isKeyword(name) and apos.isKeyword(name))
  or
  ppos.isHashSplat() and apos.isHashSplat()
  or
  ppos.isSplatAll() and apos.isSplatAll()
  or
  ppos.isAny() and argumentPositionIsNotSelf(apos)
  or
  apos.isAny() and parameterPositionIsNotSelf(ppos)
  or
  ppos.isAnyNamed() and apos.isKeyword(_)
  or
  apos.isAnyNamed() and ppos.isKeyword(_)
}
