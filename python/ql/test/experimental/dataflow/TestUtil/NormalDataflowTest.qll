import python
import experimental.dataflow.TestUtil.FlowTest
import experimental.dataflow.testConfig
private import semmle.python.dataflow.new.internal.PrintNode

class DataFlowTest extends FlowTest {
  DataFlowTest() { this = "DataFlowTest" }

  override string flowTag() { result = "flow" }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(TestConfiguration cfg | cfg.hasFlow(source, sink))
  }
}

query predicate missingAnnotationOnSINK(Location location, string error, string element) {
  error = "ERROR, you should add `# $ MISSING: flow` annotation" and
  exists(DataFlow::Node sink |
    exists(DataFlow::CallCfgNode call |
      // note: we only care about `SINK` and not `SINK_F`, so we have to reconstruct manually.
      call.getFunction().asCfgNode().(NameNode).getId() = "SINK" and
      (sink = call.getArg(_) or sink = call.getArgByName(_))
    ) and
    location = sink.getLocation() and
    element = prettyExpr(sink.asExpr()) and
    not any(TestConfiguration config).hasFlow(_, sink) and
    not exists(FalseNegativeExpectation missingResult |
      missingResult.getTag() = "flow" and
      missingResult.getLocation().getFile() = location.getFile() and
      missingResult.getLocation().getStartLine() = location.getStartLine()
    )
  )
}
