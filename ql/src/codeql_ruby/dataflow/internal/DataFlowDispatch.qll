private import ruby
private import codeql_ruby.CFG
private import DataFlowPrivate
private import codeql_ruby.typetracking.TypeTracker
private import codeql_ruby.dataflow.internal.DataFlowPublic as DataFlow
private import codeql_ruby.ast.internal.Module

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

class DataFlowCallable = CfgScope;

class DataFlowCall extends CfgNodes::ExprNodes::CallCfgNode {
  DataFlowCallable getEnclosingCallable() { result = this.getScope() }

  DataFlowCallable getTarget() {
    exists(string method, DataFlow::Node nodeTo, DataFlow::LocalSourceNode sourceNode |
      method = this.getExpr().(MethodCall).getMethodName() and
      nodeTo.asExpr() = this.getReceiver() and
      sourceNode.flowsTo(nodeTo)
    |
      exists(Module tp |
        sourceNode = trackInstance(tp) and
        result = lookupMethod(tp, method)
      )
      or
      sourceNode = trackSingletonMethod(result) and
      result.(MethodBase).getName() = method
    )
  }
}

private DataFlow::LocalSourceNode trackInstance(Module tp, TypeTracker t) {
  t.start() and
  (
    exists(CfgNodes::ExprNodes::CallCfgNode call, DataFlow::Node nodeTo |
      call.getExpr().(MethodCall).getMethodName() = "new" and
      nodeTo.asExpr() = call.getReceiver() and
      trackModule(tp).flowsTo(nodeTo) and
      result.asExpr() = call
    )
    or
    // `self` in method
    exists(Self self, Method enclosing |
      self = result.asExpr().getExpr() and
      enclosing = self.getEnclosingMethod() and
      tp = enclosing.getEnclosingModule().getModule() and
      not self.getEnclosingModule().getEnclosingMethod() = enclosing
    )
  )
  or
  exists(TypeTracker t2 | result = trackInstance(tp, t2).track(t2, t))
}

private DataFlow::LocalSourceNode trackInstance(Module tp) {
  result = trackInstance(tp, TypeTracker::end())
}

private DataFlow::LocalSourceNode trackSingletonMethod(SingletonMethod method, TypeTracker t) {
  t.start() and
  exists(DataFlow::Node nodeTo | nodeTo.asExpr().getExpr() = method.getObject() |
    result.flowsTo(nodeTo)
    or
    exists(Module m | result = trackModule(m) and trackModule(m).flowsTo(nodeTo))
  )
  or
  exists(TypeTracker t2 | result = trackSingletonMethod(method, t2).track(t2, t))
}

private DataFlow::LocalSourceNode trackSingletonMethod(SingletonMethod m) {
  result = trackSingletonMethod(m, TypeTracker::end())
}

private DataFlow::LocalSourceNode trackModule(Module tp, TypeTracker t) {
  t.start() and
  (
    // ConstantReadAccess to Module
    resolveScopeExpr(result.asExpr().getExpr()) = tp
    or
    // `self` reference to Module
    exists(Self self, ModuleBase enclosing |
      self = result.asExpr().getExpr() and
      enclosing = self.getEnclosingModule() and
      tp = enclosing.getModule() and
      not self.getEnclosingMethod().getEnclosingModule() = enclosing
    )
  )
  or
  exists(TypeTracker t2 | result = trackModule(tp, t2).track(t2, t))
}

private DataFlow::LocalSourceNode trackModule(Module tp) {
  result = trackModule(tp, TypeTracker::end())
}

/** Gets a viable run-time target for the call `call`. */
DataFlowCallable viableCallable(DataFlowCall call) { none() }

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context. This is the case if the
 * qualifier accesses a parameter of the enclosing callable `c` (including
 * the implicit `self` parameter).
 */
predicate mayBenefitFromCallContext(DataFlowCall call, Callable c) { none() }

/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) { none() }
