private import ruby
private import codeql.ruby.CFG
private import DataFlowPrivate
private import codeql.ruby.typetracking.TypeTracker
private import codeql.ruby.ast.internal.Module
private import FlowSummaryImpl as FlowSummaryImpl
private import FlowSummaryImplSpecific as FlowSummaryImplSpecific
private import codeql.ruby.dataflow.FlowSummary

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
  Location getLocation() { result = this.asCallable().getLocation() }
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

  override DataFlowCallable getEnclosingCallable() { result = c }

  override string toString() { result = "[summary] call to " + receiver + " in " + c }

  override Location getLocation() { result = c.getLocation() }
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
  CfgNodes::ExprNodes::CallCfgNode call, DataFlow::LocalSourceNode sourceNode, string method
) {
  exists(DataFlow::Node nodeTo |
    method = call.getExpr().(MethodCall).getMethodName() and
    nodeTo.asExpr() = call.getReceiver() and
    sourceNode.flowsTo(nodeTo)
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
  exists(DataFlow::LocalSourceNode sourceNode |
    methodCall(call, sourceNode, method) and
    sourceNode = trackInstance(tp)
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
            exists(SelfVariableAccess self |
              self = call.getReceiver().getExpr() and
              pragma[only_bind_out](self.getEnclosingModule().getModule().getSuperClass*()) =
                pragma[only_bind_out](result.getEnclosingModule().getModule())
            ) and
            // For now, we restrict the scope of top-level declarations to their file.
            // This may remove some plausible targets, but also removes a lot of
            // implausible targets
            if result.getEnclosingModule() instanceof Toplevel
            then result.getFile() = call.getFile()
            else any()
          else any()
        )
        or
        exists(DataFlow::LocalSourceNode sourceNode |
          methodCall(call, sourceNode, method) and
          sourceNode = trackSingletonMethod(result, method)
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
    }

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
    TAnyParameterPosition()
}

import Cached

private DataFlow::LocalSourceNode trackInstance(Module tp, TypeTracker t) {
  t.start() and
  (
    result.asExpr().getExpr() instanceof NilLiteral and tp = TResolved("NilClass")
    or
    result.asExpr().getExpr().(BooleanLiteral).isFalse() and tp = TResolved("FalseClass")
    or
    result.asExpr().getExpr().(BooleanLiteral).isTrue() and tp = TResolved("TrueClass")
    or
    result.asExpr().getExpr() instanceof IntegerLiteral and tp = TResolved("Integer")
    or
    result.asExpr().getExpr() instanceof FloatLiteral and tp = TResolved("Float")
    or
    result.asExpr().getExpr() instanceof RationalLiteral and tp = TResolved("Rational")
    or
    result.asExpr().getExpr() instanceof ComplexLiteral and tp = TResolved("Complex")
    or
    result.asExpr().getExpr() instanceof StringlikeLiteral and tp = TResolved("String")
    or
    result.asExpr() instanceof CfgNodes::ExprNodes::ArrayLiteralCfgNode and tp = TResolved("Array")
    or
    result.asExpr() instanceof CfgNodes::ExprNodes::HashLiteralCfgNode and tp = TResolved("Hash")
    or
    result.asExpr().getExpr() instanceof MethodBase and tp = TResolved("Symbol")
    or
    result.asParameter() instanceof BlockParameter and tp = TResolved("Proc")
    or
    result.asExpr().getExpr() instanceof Lambda and tp = TResolved("Proc")
    or
    exists(CfgNodes::ExprNodes::CallCfgNode call, DataFlow::Node nodeTo |
      call.getExpr().(MethodCall).getMethodName() = "new" and
      nodeTo.asExpr() = call.getReceiver() and
      trackModule(tp).flowsTo(nodeTo) and
      result.asExpr() = call
    )
    or
    // `self` in method
    tp = result.(SsaSelfDefinitionNode).getSelfScope().(Method).getEnclosingModule().getModule()
    or
    // `self` in singleton method
    flowsToSingletonMethodObject(trackInstance(tp), result.(SsaSelfDefinitionNode).getSelfScope())
    or
    // `self` in top-level
    result.(SsaSelfDefinitionNode).getSelfScope() instanceof Toplevel and
    tp = TResolved("Object")
    or
    // a module or class
    exists(Module m |
      result = trackModule(m) and
      if m.isClass() then tp = TResolved("Class") else tp = TResolved("Module")
    )
  )
  or
  exists(TypeTracker t2, StepSummary summary |
    result = trackInstanceRec(tp, t2, summary) and t = t2.append(summary)
  )
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackInstanceRec(Module tp, TypeTracker t, StepSummary summary) {
  StepSummary::step(trackInstance(tp, t), result, summary)
}

private DataFlow::LocalSourceNode trackInstance(Module tp) {
  result = trackInstance(tp, TypeTracker::end())
}

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

private DataFlow::LocalSourceNode trackBlock(Block block) {
  result = trackBlock(block, TypeTracker::end())
}

private predicate singletonMethod(MethodBase method, Expr object) {
  object = method.(SingletonMethod).getObject()
  or
  exists(SingletonClass cls |
    object = cls.getValue() and method instanceof Method and method = cls.getAMethod()
  )
}

pragma[nomagic]
private predicate flowsToSingletonMethodObject(DataFlow::LocalSourceNode nodeFrom, MethodBase method) {
  exists(DataFlow::Node nodeTo |
    nodeFrom.flowsTo(nodeTo) and
    singletonMethod(method, nodeTo.asExpr().getExpr())
  )
}

pragma[nomagic]
private predicate moduleFlowsToSingletonMethodObject(Module m, MethodBase method) {
  flowsToSingletonMethodObject(trackModule(m), method)
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackSingletonMethod0(MethodBase method, TypeTracker t) {
  t.start() and
  (
    flowsToSingletonMethodObject(result, method)
    or
    exists(Module m | result = trackModule(m) and moduleFlowsToSingletonMethodObject(m, method))
  )
  or
  exists(TypeTracker t2, StepSummary summary |
    result = trackSingletonMethod0Rec(method, t2, summary) and t = t2.append(summary)
  )
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackSingletonMethod0Rec(
  MethodBase method, TypeTracker t, StepSummary summary
) {
  StepSummary::step(trackSingletonMethod0(method, t), result, summary)
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackSingletonMethod(MethodBase m, string name) {
  result = trackSingletonMethod0(m, TypeTracker::end()) and
  name = m.getName()
}

private SsaSelfDefinitionNode selfInModule(Module tp) {
  tp = result.getSelfScope().(ModuleBase).getModule()
}

private DataFlow::LocalSourceNode trackModule(Module tp, TypeTracker t) {
  t.start() and
  (
    // ConstantReadAccess to Module
    resolveConstantReadAccess(result.asExpr().getExpr()) = tp
    or
    // `self` reference to Module
    result = selfInModule(tp)
  )
  or
  exists(TypeTracker t2, StepSummary summary |
    result = trackModuleRec(tp, t2, summary) and t = t2.append(summary)
  )
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackModuleRec(Module tp, TypeTracker t, StepSummary summary) {
  StepSummary::step(trackModule(tp, t), result, summary)
}

private DataFlow::LocalSourceNode trackModule(Module tp) {
  result = trackModule(tp, TypeTracker::end())
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

  /**
   * Holds if this position represents any parameter. This includes both positional
   * and named parameters.
   */
  predicate isAny() { this = TAnyParameterPosition() }

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
    this.isAny() and result = "any"
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

  /** Gets a textual representation of this position. */
  string toString() {
    this.isSelf() and result = "self"
    or
    this.isBlock() and result = "block"
    or
    exists(int pos | this.isPositional(pos) and result = "position " + pos)
    or
    exists(string name | this.isKeyword(name) and result = "keyword " + name)
  }
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
pragma[inline]
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
  ppos.isAny() and exists(apos)
}
