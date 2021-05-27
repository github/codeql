import cpp
import semmle.code.cpp.dataflow.DataFlow::DataFlow

class Config extends Configuration {
  Config() { this = "Config" }

  override predicate isSource(Node source) {
    source.asExpr() = any(Call c | c.getTarget().hasName("source"))
  }

  override predicate isSink(Node sink) {
    sink.asExpr() = any(Call c | c.getTarget().hasName("sink")).getAnArgument()
  }
}

from Node source, Node sink, Config config
where config.hasFlow(source, sink)
select source, sink
