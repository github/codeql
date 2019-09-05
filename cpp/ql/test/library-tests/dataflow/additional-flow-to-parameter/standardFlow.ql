import cpp
import semmle.code.cpp.dataflow.DataFlow

class TestConfig extends DataFlow::Configuration {
  TestConfig() { this = "TestConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(FunctionCall).getTarget().getName() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      call.getTarget().getName() = "sink" and
      sink.asExpr() = call.getAnArgument()
    )
  }
}

from DataFlow::Node sink, DataFlow::Node source, TestConfig cfg
where cfg.hasFlow(source, sink)
select sink, source
