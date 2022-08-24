import go
import DataFlow::PathGraph

class TestConfig extends DataFlow::Configuration {
  TestConfig() { this = "test config" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getTarget().getName() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode c | c.getTarget().getName() = "sink").getAnArgument()
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, TestConfig c
where c.hasFlowPath(source, sink)
select source, source, sink, "path"
