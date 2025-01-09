import python
import utils.test.dataflow.FlowTest
import utils.test.dataflow.testTaintConfig
private import semmle.python.dataflow.new.internal.PrintNode

module DataFlowTest implements FlowTestSig {
  string flowTag() { result = "flow" }

  predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    TestFlow::flow(source, sink)
  }
}

import MakeTest<MakeTestSig<DataFlowTest>>

query predicate missingAnnotationOnSink(Location location, string error, string element) {
  error = "ERROR, you should add `# $ MISSING: flow` annotation" and
  exists(DataFlow::Node sink |
    exists(DataFlow::CallCfgNode call |
      // note: we only care about `SINK` and not `SINK_F`, so we have to reconstruct manually.
      call.getFunction().asCfgNode().(NameNode).getId() = "SINK" and
      (sink = call.getArg(_) or sink = call.getArgByName(_))
    ) and
    location = sink.getLocation() and
    element = prettyExpr(sink.asExpr()) and
    not TestFlow::flowTo(sink) and
    not exists(FalseNegativeTestExpectation missingResult |
      missingResult.getTag() = "flow" and
      missingResult.getLocation().getFile() = location.getFile() and
      missingResult.getLocation().getStartLine() = location.getStartLine()
    )
  )
}
