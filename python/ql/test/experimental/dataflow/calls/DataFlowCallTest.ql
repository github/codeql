import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.internal.DataFlowDispatch as DataFlowDispatch
import TestUtilities.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

class DataFlowCallTest extends InlineExpectationsTest {
  DataFlowCallTest() { this = "DataFlowCallTest" }

  override string getARelevantTag() {
    result in ["call", "callType"]
    or
    result = "arg[" + any(DataFlowDispatch::ArgumentPosition pos).toString() + "]"
  }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(DataFlowDispatch::DataFlowCall call |
      location = call.getLocation() and
      element = call.toString() and
      exists(call.getCallable())
    |
      value = prettyExpr(call.getNode().getNode()) and
      tag = "call"
      or
      value = call.(DataFlowDispatch::NormalCall).getCallType().toString() and
      tag = "callType"
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
