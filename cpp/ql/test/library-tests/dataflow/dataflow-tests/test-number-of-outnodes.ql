import TestUtilities.InlineExpectationsTest
import cpp

module AstTest {
  private import semmle.code.cpp.dataflow.DataFlow::DataFlow
  private import semmle.code.cpp.dataflow.internal.DataFlowPrivate

  class AstMultipleOutNodesTest extends InlineExpectationsTest {
    AstMultipleOutNodesTest() { this = "AstMultipleOutNodesTest" }

    override string getARelevantTag() { result = "ast-count(" + any(ReturnKind k).toString() + ")" }

    override predicate hasActualResult(Location location, string element, string tag, string value) {
      exists(DataFlowCall call, int n, ReturnKind kind |
        call.getLocation() = location and
        n = strictcount(getAnOutNode(call, kind)) and
        n > 1 and
        element = call.toString() and
        tag = "ast-count(" + kind.toString() + ")" and
        value = n.toString()
      )
    }
  }
}

module IRTest {
  private import semmle.code.cpp.ir.dataflow.DataFlow
  private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate

  class IRMultipleOutNodesTest extends InlineExpectationsTest {
    IRMultipleOutNodesTest() { this = "IRMultipleOutNodesTest" }

    override string getARelevantTag() { result = "ir-count(" + any(ReturnKind k).toString() + ")" }

    override predicate hasActualResult(Location location, string element, string tag, string value) {
      exists(DataFlowCall call, int n, ReturnKind kind |
        call.getLocation() = location and
        n = strictcount(getAnOutNode(call, kind)) and
        n > 1 and
        element = call.toString() and
        tag = "ir-count(" + kind.toString() + ")" and
        value = n.toString()
      )
    }
  }
}
