import python
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

class DataFlowQueryTest extends InlineExpectationsTest {
  DataFlowQueryTest() { this = "DataFlowQueryTest" }

  override string getARelevantTag() { result = "result" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Configuration cfg, DataFlow::Node fromNode, DataFlow::Node toNode |
      cfg.hasFlow(fromNode, toNode)
    |
      location = toNode.getLocation() and
      tag = "result" and
      value = "BAD" and
      element = toNode.toString()
    )
  }
}

query predicate missingAnnotationOnSink(Location location, string error, string element) {
  error = "ERROR, you should add `# $ MISSING: result=BAD` or `result=OK` annotation" and
  exists(DataFlow::Node sink |
    exists(DataFlow::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _)) and
    location = sink.getLocation() and
    element = prettyExpr(sink.asExpr()) and
    not any(DataFlow::Configuration config).hasFlow(_, sink) and
    not exists(FalseNegativeExpectation missingResult |
      missingResult.getTag() = "result" and
      missingResult.getValue() = "BAD" and
      missingResult.getLocation().getFile() = location.getFile() and
      missingResult.getLocation().getStartLine() = location.getStartLine()
    ) and
    not exists(GoodExpectation okResult |
      okResult.getTag() = "result" and
      okResult.getValue() = "OK" and
      okResult.getLocation().getFile() = location.getFile() and
      okResult.getLocation().getStartLine() = location.getStartLine()
    )
  )
}
