import java
import semmle.code.java.dataflow.DataFlow

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(MethodCall).getMethod().hasName("source") }

  predicate isSink(DataFlow::Node n) { any() }
}

module Flow = DataFlow::Global<Config>;

from DataFlow::Node sink
where Flow::flowTo(sink)
select sink
