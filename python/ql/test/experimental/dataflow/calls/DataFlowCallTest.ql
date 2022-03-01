import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.internal.DataFlowPrivate
import TestUtilities.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

class DataFlowCallTest extends InlineExpectationsTest {
  DataFlowCallTest() { this = "DataFlowCallTest" }

  override string getARelevantTag() {
    result in ["call", "qlclass"]
    or
    result = "arg_" + [0 .. 10]
  }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(DataFlowCall call |
      location = call.getLocation() and
      element = call.toString()
    |
      value = prettyExpr(call.getNode().getNode()) and
      tag = "call"
      or
      value = call.getAQlClass() and
      tag = "qlclass"
      or
      exists(int n, DataFlow::Node arg | arg = call.getArg(n) |
        value = prettyNodeForInlineTest(arg) and
        tag = "arg_" + n
      )
    )
  }
}
