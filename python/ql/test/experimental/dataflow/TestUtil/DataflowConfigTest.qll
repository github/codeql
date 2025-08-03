import python
import experimental.dataflow.TestUtil.FlowTest
private import semmle.python.dataflow.new.internal.PrintNode

signature module FlowSig {
  predicate hasFlow(DataFlow::Node source, DataFlow::Node sink);
}

module DataflowTest<FlowSig Flow> {
  class DataFlowTest extends FlowTest {
    DataFlowTest() { this = "DataFlowTest" }

    override string flowTag() { result = "flow" }

    override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
      Flow::hasFlow(source, sink)
    }
  }

  query predicate missingAnnotationOnSink(Location location, string error, string element) {
    error = "ERROR, you should add `# $ MISSING: flow` annotation" and
    exists(DataFlow::Node sink |
      location = sink.getLocation() and
      element = prettyExpr(sink.asExpr()) and
      not Flow::hasFlow(_, sink) and
      not exists(FalseNegativeExpectation missingResult |
        missingResult.getTag() = "flow" and
        missingResult.getLocation().getFile() = location.getFile() and
        missingResult.getLocation().getStartLine() = location.getStartLine()
      )
    )
  }
}
