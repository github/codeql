import java
import semmle.code.java.dataflow.DataFlow

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(MethodCall).getMethod().getName() = "source" }

  predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().getName() = "sink"
  }
}

module Flow = DataFlow::Global<Config>;

from DataFlow::Node n1, DataFlow::Node n2
where Flow::flow(n1, n2)
select n1, n2
