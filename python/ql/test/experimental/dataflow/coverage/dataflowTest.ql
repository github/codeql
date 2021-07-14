import python
import experimental.dataflow.TestUtil.FlowTest
import experimental.dataflow.testConfig

class DataFlowTest extends FlowTest {
  DataFlowTest() { this = "DataFlowTest" }

  override string flowTag() { result = "flow" }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(TestConfiguration cfg | cfg.hasFlow(source, sink))
  }
}
