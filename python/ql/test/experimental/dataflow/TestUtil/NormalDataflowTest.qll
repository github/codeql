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

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    super.hasActualResult(location, element, tag, value)
  }
}
