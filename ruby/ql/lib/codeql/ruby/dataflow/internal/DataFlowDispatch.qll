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
  TBreakReturnKind()

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

/** A callable defined in library code, identified by a unique string. */
abstract class LibraryCallable extends string {
  bindingset[this]
  LibraryCallable() { any() }

  /** Gets a call to this library callable. */
  abstract Call getACall();
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

pragma[nomagic]
private predicate methodCall(
  CfgNodes::ExprNodes::CallCfgNode call, DataFlow::Node receiver, string method
) {
  method = call.getExpr().(MethodCall).getMethodName() and
  receiver.asExpr() = call.getReceiver()
}

pragma[nomagic]
private predicate flowsToMethodCall(
  CfgNodes::ExprNodes::CallCfgNode call, DataFlow::LocalSourceNode sourceNode, string method
) {
  exists(DataFlow::Node receiver |
    methodCall(call, receiver, method) and
    sourceNode.flowsTo(receiver)
  )
}

private Block yieldCall(CfgNodes::ExprNodes::CallCfgNode call) {
  call.getExpr() instanceof YieldCall and
  exists(BlockParameterNode node |
    node = trackBlock(result) and
    node.getMethod() = call.getExpr().getEnclosingMethod()
  )
}

pragma[nomagic]
private predicate superCall(CfgNodes::ExprNodes::CallCfgNode call, Module superClass, string method) {
  call.getExpr() instanceof SuperCall and
  exists(Module tp |
    tp = call.getExpr().getEnclosingModule().getModule() and
    superClass = tp.getSuperClass() and
    method = call.getExpr().getEnclosingMethod().getName()
  )
}

pragma[nomagic]
private predicate instanceMethodCall(CfgNodes::ExprNodes::CallCfgNode call, Module tp, string method) {
  exists(DataFlow::Node receiver, Module m, boolean exact |
    methodCall(call, receiver, method) and
    receiver = trackInstance(m, exact)
  |
    tp = m
    or
    // When we don't know the exact type, it could be any sub class
    exact = false and
    tp.getSuperClass+() = m
  )
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
private predicate asModulePattern(SsaDefinitionNode def, Module m) {
  exists(AsPattern ap |
    m = resolveConstantReadAccess(ap.getPattern()) and
    def.getDefinition().(Ssa::WriteDefinition).getWriteAccess() = ap.getVariableAccess()
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

  cached
  CfgScope getTarget(CfgNodes::ExprNodes::CallCfgNode call) {
    // Temporarily disable operation resolution (due to bad performance)
    not call.getExpr() instanceof Operation and
    (
      exists(string method |
        exists(Module tp |
          instanceMethodCall(call, tp, method) and
          result = lookupMethod(tp, method) and
          if result.(Method).isPrivate()
          then
            call.getReceiver().getExpr() instanceof SelfVariableAccess and
            // For now, we restrict the scope of top-level declarations to their file.
            // This may remove some plausible targets, but also removes a lot of
            // implausible targets
            if result.getEnclosingModule() instanceof Toplevel
            then result.getFile() = call.getFile()
            else any()
          else any()
        )
        or
        // singleton method defined on an instance, e.g.
        // ```rb
        // c = C.new
        // def c.singleton; end # <- result
        // c.singleton          # <- call
        // ```
        exists(DataFlow::Node receiver |
          methodCall(call, receiver, method) and
          receiver = trackSingletonMethodOnInstance(result, method)
        )
        or
        // singleton method defined on a module
        exists(DataFlow::Node sourceNode, Module m |
          flowsToMethodCall(call, sourceNode, method) and
          singletonMethodOnModule(result, method, m)
        |
          // ```rb
          // def C.singleton; end # <- result
          // C.singleton          # <- call
          // ```
          sourceNode = trackModuleAccess(m)
          or
          // ```rb
          // class C
          //   def self.singleton; end # <- result
          //   self.singleton          # <- call
          // end
          // ```
          selfInModule(sourceNode.(SsaSelfDefinitionNode).getVariable(), m)
          or
          // ```rb
          // class C
          //   def self.singleton; end # <- result
          //   def self.other
          //     self.singleton        # <- call
          //   end
          // end
          // ```
          selfInMethod(sourceNode.(SsaSelfDefinitionNode).getVariable(), _, m.getSuperClass*())
        )
      )
      or
      exists(Module superClass, string method |
        superCall(call, superClass, method) and
        result = lookupMethod(superClass, method)
      )
      or
      result = yieldCall(call)
    )
  }

  /** Gets a viable run-time target for the call `call`. */
  cached
  DataFlowCallable viableCallable(DataFlowCall call) {
    result = TCfgScope(getTarget(call.asCall())) and
    not call.asCall().getExpr() instanceof YieldCall // handled by `lambdaCreation`/`lambdaCall`
    or
    exists(LibraryCallable callable |
      result = TLibraryCallable(callable) and
      call.asCall().getExpr() = callable.getACall()
    )
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

pragma[nomagic]
private DataFlow::LocalSourceNode trackModuleAccessRec(Module m, TypeTracker t, StepSummary summary) {
  StepSummary::step(trackModuleAccess(m, t), result, summary)
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackModuleAccess(Module m) {
  result = trackModuleAccess(m, TypeTracker::end())
}

pragma[nomagic]
private DataFlow::Node trackInstance(Module tp, boolean exact, TypeTracker t) {
  t.start() and
  (
    result.asExpr().getExpr() instanceof NilLiteral and
    tp = TResolved("NilClass") and
    exact = true
    or
    result.asExpr().getExpr().(BooleanLiteral).isFalse() and
    tp = TResolved("FalseClass") and
    exact = true
    or
    result.asExpr().getExpr().(BooleanLiteral).isTrue() and
    tp = TResolved("TrueClass") and
    exact = true
    or
    result.asExpr().getExpr() instanceof IntegerLiteral and
    tp = TResolved("Integer") and
    exact = true
    or
    result.asExpr().getExpr() instanceof FloatLiteral and
    tp = TResolved("Float") and
    exact = true
    or
    result.asExpr().getExpr() instanceof RationalLiteral and
    tp = TResolved("Rational") and
    exact = true
    or
    result.asExpr().getExpr() instanceof ComplexLiteral and
    tp = TResolved("Complex") and
    exact = true
    or
    result.asExpr().getExpr() instanceof StringlikeLiteral and
    tp = TResolved("String") and
    exact = true
    or
    result.asExpr() instanceof CfgNodes::ExprNodes::ArrayLiteralCfgNode and
    tp = TResolved("Array") and
    exact = true
    or
    result.asExpr() instanceof CfgNodes::ExprNodes::HashLiteralCfgNode and
    tp = TResolved("Hash") and
    exact = true
    or
    result.asExpr().getExpr() instanceof MethodBase and
    tp = TResolved("Symbol") and
    exact = true
    or
    result.asParameter() instanceof BlockParameter and
    tp = TResolved("Proc") and
    exact = true
    or
    result.asExpr().getExpr() instanceof Lambda and
    tp = TResolved("Proc") and
    exact = true
    or
    exists(CfgNodes::ExprNodes::CallCfgNode call, DataFlow::LocalSourceNode sourceNode |
      flowsToMethodCall(call, sourceNode, "new") and
      exact = true and
      result.asExpr() = call
    |
      // `C.new`
      sourceNode = trackModuleAccess(tp)
      or
      // `self.new` inside a module
      selfInModule(sourceNode.(SsaSelfDefinitionNode).getVariable(), tp)
      or
      // `self.new` inside a singleton method
      selfInMethod(sourceNode.(SsaSelfDefinitionNode).getVariable(), any(SingletonMethod sm), tp)
    )
    or
    // `self` reference in method or top-level (but not in module or singleton method,
    // where instance methods cannot be called; only singleton methods)
    result =
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
    or
    // `in C => c then c.foo`
    asModulePattern(result, tp) and
    exact = false
    or
    // `case object when C then object.foo`
    hasAdjacentTypeCheckedReads(_, _, result.asExpr(), tp) and
    exact = false
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

/**
 * We exclude steps into `self` parameters and type checked variables. For those,
 * we instead rely on the type of the enclosing module resp. the type being checked
 * against, and apply an open-world assumption when determining possible dispatch
 * targets.
 */
pragma[nomagic]
private DataFlow::Node trackInstanceRec(Module tp, TypeTracker t, boolean exact, StepSummary summary) {
  exists(DataFlow::Node mid | mid = trackInstance(tp, exact, t) |
    StepSummary::smallstep(mid, result, summary)
    or
    localFlowStep(mid, result, summary)
  ) and
  not result instanceof SelfParameterNode and
  not hasAdjacentTypeCheckedReads(_, _, result.asExpr(), _)
}

pragma[nomagic]
private DataFlow::Node trackInstance(Module tp, boolean exact) {
  result = trackInstance(tp, exact, TypeTracker::end())
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
 * ```
 */
pragma[nomagic]
private predicate singletonMethodOnModule(MethodBase method, string name, Module m) {
  exists(Expr object |
    singletonMethod(method, name, object) and
    selfInModule(object.(SelfVariableReadAccess).getVariable(), m)
  )
  or
  flowsToSingletonMethodObject(trackModuleAccess(m), method, name)
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
 * ```
 */
pragma[nomagic]
predicate singletonMethodOnInstance(MethodBase method, string name, Expr object) {
  singletonMethod(method, name, object) and
  not selfInModule(object.(SelfVariableReadAccess).getVariable(), _) and
  // cannot use `trackModuleAccess` because of negative recursion
  not exists(resolveConstantReadAccess(object))
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
  exists(
    CfgNodes::ExprNodes::CallCfgNode call, DataFlow::Node arg, DataFlow::ParameterNode p,
    Expr nodeFromPreExpr
  |
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

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context. This is the case if the
 * qualifier accesses a parameter of the enclosing callable `c` (including
 * the implicit `self` parameter).
 */
predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable c) { none() }

/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) { none() }

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
  ppos.isAny() and argumentPositionIsNotSelf(apos)
  or
  apos.isAny() and parameterPositionIsNotSelf(ppos)
  or
  ppos.isAnyNamed() and apos.isKeyword(_)
  or
  apos.isAnyNamed() and ppos.isKeyword(_)
}
