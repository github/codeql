import java
import semmle.code.java.dataflow.DataFlow

class Config extends DataFlow::Configuration {
  Config() { this = "testconfig" }

  override predicate isSource(DataFlow::Node x) {
    x.asExpr() instanceof IntegerLiteral and x.getEnclosingCallable().fromSource()
  }

  override predicate isSink(DataFlow::Node x) {
    x.asExpr().(Argument).getCall().getCallee().getName() = "sink"
  }
}

from Config c, DataFlow::Node source, DataFlow::Node sink
where c.hasFlow(source, sink)
select source, sink
