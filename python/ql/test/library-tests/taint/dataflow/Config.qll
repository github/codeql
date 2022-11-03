import python
import semmle.python.dataflow.DataFlow

class TestConfiguration extends DataFlow::Configuration {
  TestConfiguration() { this = "Test configuration" }

  override predicate isSource(ControlFlowNode source) { source.(NameNode).getId() = "SOURCE" }

  override predicate isSink(ControlFlowNode sink) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" and
      sink = call.getAnArg()
    )
  }
}
