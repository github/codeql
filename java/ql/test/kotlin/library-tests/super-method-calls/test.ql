import java
import semmle.code.java.dataflow.DataFlow

class Config extends DataFlow::Configuration {
  Config() { this = "abc" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().getName() = "source"
  }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().getName() = "sink"
  }
}

from Config c, DataFlow::Node n1, DataFlow::Node n2
where c.hasFlow(n1, n2)
select n1, n2
