import java
import semmle.code.java.dataflow.DataFlow

class Config extends DataFlow::Configuration {
  Config() { this = "config" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getCallee().getName() = "source"
  }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().getName() = "sink"
  }
}

from Config c, DataFlow::Node source, DataFlow::Node sink
where c.hasFlow(source, sink)
select source, sink, source.getEnclosingCallable()
