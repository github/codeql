import python
import experimental.dataflow.TestUtil.FlowTest
private import semmle.python.dataflow.new.internal.PrintNode

class DataFlowQueryTest extends FlowTest {
  DataFlowQueryTest() { this = "DataFlowQueryTest" }

  override string flowTag() { result = "flow" }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(DataFlow::Configuration cfg | cfg.hasFlow(source, sink))
  }
}

query predicate missingAnnotationOnSink(Location location, string error, string element) {
  error = "ERROR, you should add `# $ MISSING: flow` annotation" and
  exists(DataFlow::Node sink |
    exists(DataFlow::Configuration cfg | cfg.isSink(sink)) and
    location = sink.getLocation() and
    element = prettyExpr(sink.asExpr()) and
    not any(DataFlow::Configuration config).hasFlow(_, sink) and
    not exists(FalseNegativeExpectation missingResult |
      missingResult.getTag() = "flow" and
      missingResult.getLocation().getFile() = location.getFile() and
      missingResult.getLocation().getStartLine() = location.getStartLine()
    )
  )
}
