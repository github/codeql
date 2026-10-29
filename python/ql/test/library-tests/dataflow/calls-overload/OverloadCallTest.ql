/**
 * Test that `@typing.overload` stubs are not resolved as call targets.
 */

import python
import semmle.python.dataflow.new.internal.DataFlowDispatch as DataFlowDispatch
import utils.test.InlineExpectationsTest

module OverloadCallTest implements TestSig {
  string getARelevantTag() { result = "init" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(DataFlowDispatch::DataFlowCall call, Function target |
      location = call.getLocation() and
      element = call.toString() and
      DataFlowDispatch::resolveCall(call.getNode(), target, _) and
      target.getName() = "__init__"
    |
      value = target.getQualifiedName() + ":" + target.getLocation().getStartLine().toString() and
      tag = "init"
    )
  }
}

import MakeTest<OverloadCallTest>
