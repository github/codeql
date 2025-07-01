/** Definitions for reasoning about multiple or missing calls to superclass methods. */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowDispatch

predicate multipleCallsToSuperclassMethod(Function meth, Function calledMulti, string name) {
  exists(DataFlow::MethodCallNode call1, DataFlow::MethodCallNode call2, Class cls |
    meth.getName() = name and
    meth.getScope() = cls and
    call1.asExpr() != call2.asExpr() and
    calledMulti = getASuperCallTarget(cls, meth, call1) and
    calledMulti = getASuperCallTarget(cls, meth, call2) and
    nonTrivial(calledMulti)
  )
}

Function getASuperCallTarget(Class mroBase, Function meth, DataFlow::MethodCallNode call) {
  meth = call.getScope() and
  getADirectSuperclass*(mroBase) = meth.getScope() and
  call.calls(_, meth.getName()) and
  exists(Function target, Class nextMroBase |
    (result = target or result = getASuperCallTarget(nextMroBase, target, _))
  |
    superCall(call, _) and
    nextMroBase = mroBase and
    target =
      findFunctionAccordingToMroKnownStartingClass(getNextClassInMroKnownStartingClass(meth.getScope(),
          mroBase), mroBase, meth.getName())
    or
    callsMethodOnClassWithSelf(meth, call, nextMroBase, _) and
    target = findFunctionAccordingToMro(nextMroBase, meth.getName())
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
