/** Definitions for reasoning about multiple or missing calls to superclass methods. */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowDispatch
import codeql.util.Option

predicate multipleCallsToSuperclassMethod(Function meth, Function calledMulti, string name) {
  exists(DataFlow::MethodCallNode call1, DataFlow::MethodCallNode call2, Class cls |
    meth.getName() = name and
    meth.getScope() = cls and
    call1.asExpr() != call2.asExpr() and
    calledMulti = getASuperCallTargetFromCall(cls, meth, call1, name) and
    calledMulti = getASuperCallTargetFromCall(cls, meth, call2, name) and
    nonTrivial(calledMulti)
  )
}

Function getASuperCallTargetFromCall(
  Class mroBase, Function meth, DataFlow::MethodCallNode call, string name
) {
  meth = call.getScope() and
  getADirectSuperclass*(mroBase) = meth.getScope() and
  meth.getName() = name and
  call.calls(_, name) and
  exists(Class targetCls | result = getASuperCallTargetFromClass(mroBase, targetCls, name) |
    superCall(call, _) and
    targetCls = getNextClassInMroKnownStartingClass(meth.getScope(), mroBase)
    or
    callsMethodOnClassWithSelf(meth, call, targetCls, _)
  )
}

Function getASuperCallTargetFromClass(Class mroBase, Class cls, string name) {
  exists(Function target |
    target = findFunctionAccordingToMroKnownStartingClass(cls, mroBase, name) and
    (result = target or result = getASuperCallTargetFromCall(mroBase, target, _, name))
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

predicate missingCallToSuperclassMethod(Class base, Function shouldCall, string name) {
  shouldCall.getName() = name and
  shouldCall.getScope() = getADirectSuperclass+(base) and
  not shouldCall = getASuperCallTargetFromClass(base, base, name) and
  nonTrivial(shouldCall) and
  // "Benefit of the doubt" - if somewhere in the chain we call an unknown superclass, assume all the necessary parent methods are called from it
  not callsMethodOnUnknownClassWithSelf(getASuperCallTargetFromClass(base, base, name), name)
}

predicate missingCallToSuperclassMethodRestricted(Class base, Function shouldCall, string name) {
  missingCallToSuperclassMethod(base, shouldCall, name) and
  not exists(Class subBase |
    subBase = getADirectSubclass+(base) and
    missingCallToSuperclassMethod(subBase, shouldCall, name)
  ) and
  not exists(Function superShouldCall |
    superShouldCall.getScope() = getADirectSuperclass+(shouldCall.getScope()) and
    missingCallToSuperclassMethod(base, superShouldCall, name)
  )
}

Function getPossibleMissingSuper(Class base, Function shouldCall, string name) {
  missingCallToSuperclassMethod(base, shouldCall, name) and
  exists(Function baseMethod |
    baseMethod.getScope() = base and
    baseMethod.getName() = name and
    // the base method calls super, so is presumably expecting every method called in the MRO chain to do so
    callsSuper(baseMethod) and
    // result is something that does get called in the chain
    result = getASuperCallTargetFromClass(base, base, name) and
    // it doesn't call super
    not callsSuper(result) and
    // if it did call super, it would resolve to the missing method
    shouldCall =
      findFunctionAccordingToMroKnownStartingClass(getNextClassInMroKnownStartingClass(result
              .getScope(), base), base, name)
  )
}

private module FunctionOption = Option<Function>;

class FunctionOption extends FunctionOption::Option {
  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.asSome()
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    or
    this.isNone() and
    filepath = "" and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }

  string getQualifiedName() {
    result = this.asSome().getQualifiedName()
    or
    this.isNone() and
    result = ""
  }
}

bindingset[name]
FunctionOption getPossibleMissingSuperOption(Class base, Function shouldCall, string name) {
  result.asSome() = getPossibleMissingSuper(base, shouldCall, name)
  or
  not exists(getPossibleMissingSuper(base, shouldCall, name)) and
  result.isNone()
}
