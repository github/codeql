import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.internal.DataFlowDispatch as DataFlowDispatch
import utils.test.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

module DataFlowCallTest implements TestSig {
  string getARelevantTag() {
    result in ["call", "callType"]
    or
    result = "arg[" + any(DataFlowDispatch::ArgumentPosition pos).toString() + "]"
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(DataFlowDispatch::DataFlowCall call |
      location = call.getLocation() and
      element = call.toString() and
      exists(call.getCallable())
    |
      value = prettyExpr(call.getNode().getNode()) and
      tag = "call"
      or
      exists(DataFlowDispatch::CallType callType |
        DataFlowDispatch::resolveCall(call.getNode(), _, callType) and
        value = callType.toString() and
        tag = "callType"
      )
      or
      exists(DataFlowDispatch::ArgumentPosition pos, DataFlow::Node arg |
        arg = call.getArgument(pos)
      |
        value = prettyNodeForInlineTest(arg) and
        tag = "arg[" + pos + "]"
      )
    )
  }
}

import MakeTest<DataFlowCallTest>
