import python
import TestUtilities.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.DataFlowDispatch as TT

/** A call graph edge resolved based on Type Trackers */
predicate pointsToCallEdge(CallNode call, Function callable) {
  exists(PythonFunctionValue funcValue |
    funcValue.getScope() = callable and
    call = funcValue.getACall()
  )
}

/** A call graph edge resolved based on Type Trackers */
predicate typeTrackerCallEdge(CallNode call, Function callable) {
  exists(TT::DataFlowCallable dfCallable, TT::DataFlowCall dfCall |
    dfCallable.getScope() = callable and
    dfCall.getNode() = call and
    dfCallable = TT::viableCallable(dfCall)
  )
}

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
      (
        // note: `target.getQualifiedName` for Lambdas is just "lambda", so is not very useful :|
        not target.isLambda() and
        value = target.getQualifiedName()
        or
        target.isLambda() and
        value =
          "lambda[" + target.getLocation().getFile().getShortName() + ":" +
            target.getLocation().getStartLine() + ":" + target.getLocation().getStartColumn() + "]"
      )
    )
  }
}

query predicate debug_callableNotUnique(Function callable, string message) {
  exists(Function f | f != callable and f.getQualifiedName() = callable.getQualifiedName()) and
  message =
    "Qualified function name '" + callable.getQualifiedName() + "' is not unique. Please fix."
}
