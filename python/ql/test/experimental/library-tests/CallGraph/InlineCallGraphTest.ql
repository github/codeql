import python
import TestUtilities.InlineExpectationsTest

/** Holds when `call` is resolved to `callable` using points-to based call-graph. */
predicate pointsToCallEdge(CallNode call, Function callable) {
  exists(PythonFunctionValue funcValue |
    funcValue.getScope() = callable and
    call = funcValue.getACall()
  )
}

/** Holds when `call` is resolved to `callable` using type-tracking based call-graph. */
predicate typeTrackerCallEdge(CallNode call, Function callable) { none() }

class CallGraphTest extends InlineExpectationsTest {
  CallGraphTest() { this = "CallGraphTest" }

  override string getARelevantTag() { result in ["pt", "tt"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(CallNode call, Function target |
      tag = "tt" and
      typeTrackerCallEdge(call, target)
      or
      tag = "pt" and
      pointsToCallEdge(call, target)
    |
      location = call.getLocation() and
      element = call.toString() and
      value = betterQualName(target)
    )
  }
}

bindingset[func]
string betterQualName(Function func) {
  // note: `target.getQualifiedName` for Lambdas is just "lambda", so is not very useful :|
  not func.isLambda() and
  result = func.getQualifiedName()
  or
  func.isLambda() and
  result =
    "lambda[" + func.getLocation().getFile().getShortName() + ":" +
      func.getLocation().getStartLine() + ":" + func.getLocation().getStartColumn() + "]"
}

query predicate debug_callableNotUnique(Function callable, string message) {
  exists(Function f | f != callable and f.getQualifiedName() = callable.getQualifiedName()) and
  message =
    "Qualified function name '" + callable.getQualifiedName() + "' is not unique. Please fix."
}

query predicate pointsTo_found_typeTracker_notFound(CallNode call, string qualname) {
  exists(Function target |
    pointsToCallEdge(call, target) and
    not typeTrackerCallEdge(call, target) and
    qualname = betterQualName(target)
  )
}

query predicate typeTracker_found_pointsTo_notFound(CallNode call, string qualname) {
  exists(Function target |
    not pointsToCallEdge(call, target) and
    typeTrackerCallEdge(call, target) and
    qualname = betterQualName(target)
  )
}
