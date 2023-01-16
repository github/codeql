import python
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

class DataFlowQueryTest extends InlineExpectationsTest {
  DataFlowQueryTest() { this = "DataFlowQueryTest" }

  override string getARelevantTag() { result = "result" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Configuration cfg, DataFlow::Node sink | cfg.hasFlowTo(sink) |
      location = sink.getLocation() and
      tag = "result" and
      value = "BAD" and
      element = sink.toString()
    )
  }

  // We allow annotating any sink with `result=OK` to signal
  // safe sinks.
  // Sometimes a line contains both an alert and a safe sink.
  // In this situation, the annotation form `OK(safe sink)`
  // can be useful.
  override predicate hasOptionalResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Configuration cfg, DataFlow::Node sink |
      cfg.isSink(sink) or cfg.isSink(sink, _)
    |
      location = sink.getLocation() and
      tag = "result" and
      value in ["OK", "OK(" + prettyNode(sink) + ")"] and
      element = sink.toString()
    )
  }
}

query predicate missingAnnotationOnSink(Location location, string error, string element) {
  error = "ERROR, you should add `# $ MISSING: result=BAD` or `result=OK` annotation" and
  exists(DataFlow::Node sink |
    exists(sink.getLocation().getFile().getRelativePath()) and
    exists(DataFlow::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _)) and
    location = sink.getLocation() and
    element = prettyExpr(sink.asExpr()) and
    not exists(DataFlow::Configuration cfg | cfg.hasFlowTo(sink)) and
    not exists(FalseNegativeExpectation missingResult |
      missingResult.getTag() = "result" and
      missingResult.getValue() = "BAD" and
      missingResult.getLocation().getFile() = location.getFile() and
      missingResult.getLocation().getStartLine() = location.getStartLine()
    ) and
    not exists(GoodExpectation okResult |
      okResult.getTag() = "result" and
      okResult.getValue() in ["OK", "OK(" + prettyNode(sink) + ")"] and
      okResult.getLocation().getFile() = location.getFile() and
      okResult.getLocation().getStartLine() = location.getStartLine()
    )
  )
}
