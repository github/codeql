/** Definitions for reasoning about multiple or missing calls to superclass methods. */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowDispatch
import codeql.util.Option

/** Holds if `meth` is a method named `name` that transitively calls `calledMulti` of the same name via the calls `call1` and `call2`. */
predicate multipleCallsToSuperclassMethod(
  Function meth, Function calledMulti, DataFlow::MethodCallNode call1,
  DataFlow::MethodCallNode call2, string name
) {
  exists(Class cls |
    meth.getName() = name and
    meth.getScope() = cls and
    locationBefore(call1.getLocation(), call2.getLocation()) and
    rankedSuperCallByLocation(1, cls, meth, call1, name, calledMulti) and
    rankedSuperCallByLocation(2, cls, meth, call2, name, calledMulti) and
    nonTrivial(calledMulti)
  )
}

predicate rankedSuperCallByLocation(
  int i, Class mroBase, Function meth, DataFlow::MethodCallNode call, string name, Function target
) {
  call =
    rank[i](DataFlow::MethodCallNode calli |
      target = getASuperCallTargetFromCall(mroBase, meth, calli, name)
    |
      calli order by calli.getLocation().getStartLine(), calli.getLocation().getStartColumn()
    )
}

/** Holds if l1 comes before l2, assuming they're in the same file. */
pragma[inline]
private predicate locationBefore(Location l1, Location l2) {
  l1.getStartLine() < l2.getStartLine()
  or
  l1.getStartLine() = l2.getStartLine() and
  l1.getStartColumn() < l2.getStartColumn()
}

/** Gets a method transitively called by `meth` named `name` with `call` that it overrides, with `mroBase` as the type determining the MRO to search. */
Function getASuperCallTargetFromCall(
  Class mroBase, Function meth, DataFlow::MethodCallNode call, string name
) {
  exists(Function target | target = getDirectSuperCallTargetFromCall(mroBase, meth, call, name) |
    result = target
    or
    result = getASuperCallTargetFromCall(mroBase, target, _, name)
  )
}

/** Gets the method called by `meth` named `name` with `call`, with `mroBase` as the type determining the MRO to search. */
Function getDirectSuperCallTargetFromCall(
  Class mroBase, Function meth, DataFlow::MethodCallNode call, string name
) {
  meth = call.getScope() and
  meth.getName() = name and
  call.calls(_, name) and
  mroBase = getADirectSubclass*(meth.getScope()) and
  exists(Class targetCls |
    // the differences between 0-arg and 2-arg super is not considered; we assume each super uses the mro of the instance `self`
    superCall(call, _) and
    targetCls = getNextClassInMroKnownStartingClass(meth.getScope(), mroBase) and
    result = findFunctionAccordingToMroKnownStartingClass(targetCls, mroBase, name)
    or
    // targetCls is the mro base for this lookup.
    // note however that if the call we find uses super(), that still uses the mro of the instance `self`
    // assuming it's 0-arg or is 2-arg with `self` as second arg.
    callsMethodOnClassWithSelf(meth, call, targetCls, _) and
    result = findFunctionAccordingToMroKnownStartingClass(targetCls, targetCls, name)
  )
}

/** Gets a method that is transitively called by a call to `cls.<name>`, with `mroBase` as the type determining the MRO to search. */
Function getASuperCallTargetFromClass(Class mroBase, Class cls, string name) {
  exists(Function target |
    target = findFunctionAccordingToMroKnownStartingClass(cls, mroBase, name) and
    (
      result = target
      or
      result = getASuperCallTargetFromCall(mroBase, target, _, name)
    )
  )
}

/** Holds if `meth` does something besides calling a superclass method. */
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

/** Holds if `call` is a call to `super().<name>`. No distinction is made between 0- and 2- arg super calls. */
predicate superCall(DataFlow::MethodCallNode call, string name) {
  exists(DataFlow::Node sup |
    call.calls(sup, name) and
    sup = API::builtin("super").getACall()
  )
}

/** Holds if `meth` calls a `super()` method of the same name. */
predicate callsSuper(Function meth) {
  exists(DataFlow::MethodCallNode call |
    call.getScope() = meth and
    superCall(call, meth.getName())
  )
}

/** Holds if `meth` calls `target.<name>(self, ...)` with the call `call`. */
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

/** Holds if `meth` calls a method named `name` passing its `self` argument as its first parameter, but the class it refers to is unknown. */
predicate callsMethodOnUnknownClassWithSelf(Function meth, string name) {
  exists(DataFlow::MethodCallNode call, DataFlow::Node callTarget, DataFlow::ParameterNode self |
    call.calls(callTarget, name) and
    self.getParameter() = meth.getArg(0) and
    self.(DataFlow::LocalSourceNode).flowsTo(call.getArg(0)) and
    not callTarget = classTracker(any(Class target))
  )
}

/** Holds if `base` does not call a superclass method `shouldCall` named `name` when it appears it should. */
predicate missingCallToSuperclassMethod(Class base, Function shouldCall, string name) {
  shouldCall.getName() = name and
  shouldCall.getScope() = getADirectSuperclass+(base) and
  not shouldCall = getASuperCallTargetFromClass(base, base, name) and
  nonTrivial(shouldCall) and
  // "Benefit of the doubt" - if somewhere in the chain we call an unknown superclass, assume all the necessary parent methods are called from it
  not callsMethodOnUnknownClassWithSelf(getASuperCallTargetFromClass(base, base, name), name)
}

/**
 * Holds if `base` does not call a superclass method `shouldCall` named `name` when it appears it should.
 * Results are restricted to hold only for the highest `base` class and the lowest `shouldCall` method in the hierarchy for which this applies.
 */
predicate missingCallToSuperclassMethodRestricted(Class base, Function shouldCall, string name) {
  missingCallToSuperclassMethod(base, shouldCall, name) and
  not exists(Class superBase |
    // Alert only on the highest base class that has the issue
    superBase = getADirectSuperclass+(base) and
    missingCallToSuperclassMethod(superBase, shouldCall, name)
  ) and
  not exists(Function subShouldCall |
    // Mention in the alert only the lowest method we're missing the call to
    subShouldCall.getScope() = getADirectSubclass+(shouldCall.getScope()) and
    missingCallToSuperclassMethod(base, subShouldCall, name)
  )
}

/**
 * If `base` contains a `super()` call, gets a method in the inheritance hierarchy of `name` in the MRO of `base`
 * that does not contain a `super()` call, but would call `shouldCall` if it did, which does not otherwise get called
 * during a call to `base.<name>`.
 */
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

/** An optional `Function`. */
class FunctionOption extends LocatableOption<Location, Function>::Option {
  /** Gets the qualified name of this function, or the empty string if it is None. */
  string getQualifiedName() {
    this.isNone() and result = ""
    or
    result = this.asSome().getQualifiedName()
  }
}

/** Gets the result of `getPossibleMissingSuper`, or None if none exists. */
bindingset[name]
FunctionOption getPossibleMissingSuperOption(Class base, Function shouldCall, string name) {
  result.asSome() = getPossibleMissingSuper(base, shouldCall, name)
  or
  not exists(getPossibleMissingSuper(base, shouldCall, name)) and
  result.isNone()
}
