/** Definitions for reasoning about multiple or missing calls to superclass methods. */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowDispatch

// Helper predicates for multiple call to __init__/__del__ queries.
pragma[noinline]
private predicate multiple_invocation_paths_helper(
  FunctionInvocation top, FunctionInvocation i1, FunctionInvocation i2, FunctionObject multi
) {
  i1 != i2 and
  i1 = top.getACallee+() and
  i2 = top.getACallee+() and
  i1.getFunction() = multi
}

pragma[noinline]
private predicate multiple_invocation_paths(
  FunctionInvocation top, FunctionInvocation i1, FunctionInvocation i2, FunctionObject multi
) {
  multiple_invocation_paths_helper(top, i1, i2, multi) and
  i2.getFunction() = multi
}

/** Holds if `self.name` calls `multi` by multiple paths, and thus calls it more than once. */
predicate multiple_calls_to_superclass_method(ClassObject self, FunctionObject multi, string name) {
  exists(FunctionInvocation top, FunctionInvocation i1, FunctionInvocation i2 |
    multiple_invocation_paths(top, i1, i2, multi) and
    top.runtime(self.declaredAttribute(name)) and
    self.getASuperType().declaredAttribute(name) = multi
  |
    // Only called twice if called from different functions,
    // or if one call-site can reach the other.
    i1.getCall().getScope() != i2.getCall().getScope()
    or
    i1.getCall().strictlyReaches(i2.getCall())
  )
}

predicate nonTrivial(Function meth) {
  exists(Stmt s | s = meth.getAStmt() |
    not s instanceof Pass and
    not exists(DataFlow::Node call | call.asExpr() = s.(ExprStmt).getValue() |
      superCall(call, meth.getName())
      or
      callsMethodOnClassWithSelf(meth, call, _, meth.getName())
    )
  ) and
  exists(meth.getANormalExit()) // doesn't always raise an exception
}

predicate superCall(DataFlow::MethodCallNode call, string name) {
  exists(DataFlow::Node sup |
    call.calls(sup, name) and
    sup = API::builtin("super").getACall()
  )
}

predicate callsSuper(Function meth) {
  exists(DataFlow::MethodCallNode call |
    call.getScope() = meth and
    superCall(call, meth.getName())
  )
}

predicate callsMethodOnClassWithSelf(
  Function meth, DataFlow::MethodCallNode call, Class target, string name
) {
  exists(DataFlow::Node callTarget, DataFlow::ParameterNode self |
    call.calls(callTarget, name) and
    self.getParameter() = meth.getArg(0) and
    self.(DataFlow::LocalSourceNode).flowsTo(call.getArg(0)) and
    callTarget = classTracker(target)
  )
}

predicate callsMethodOnUnknownClassWithSelf(Function meth, string name) {
  exists(DataFlow::MethodCallNode call, DataFlow::Node callTarget, DataFlow::ParameterNode self |
    call.calls(callTarget, name) and
    self.getParameter() = meth.getArg(0) and
    self.(DataFlow::LocalSourceNode).flowsTo(call.getArg(0)) and
    not exists(Class target | callTarget = classTracker(target))
  )
}

predicate mayProceedInMro(Class a, Class b, Class mroStart) {
  b = getNextClassInMroKnownStartingClass(a, mroStart)
  or
  exists(Class mid |
    mid = getNextClassInMroKnownStartingClass(a, mroStart) and
    mayProceedInMro(mid, b, mroStart)
  )
}

predicate missingCallToSuperclassMethod(
  Function base, Function shouldCall, Class mroStart, string name
) {
  base.getName() = name and
  shouldCall.getName() = name and
  not callsSuper(base) and
  not callsMethodOnUnknownClassWithSelf(base, name) and
  nonTrivial(shouldCall) and
  base.getScope() = getADirectSuperclass*(mroStart) and
  mayProceedInMro(base.getScope(), shouldCall.getScope(), mroStart) and
  not exists(Class called |
    (
      callsMethodOnClassWithSelf(base, _, called, name)
      or
      callsMethodOnClassWithSelf(findFunctionAccordingToMro(mroStart, name), _, called, name)
    ) and
    shouldCall.getScope() = getADirectSuperclass*(called)
  )
}
