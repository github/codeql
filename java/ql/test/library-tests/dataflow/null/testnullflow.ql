import java
import semmle.code.java.dataflow.DataFlow

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr() instanceof NullLiteral }

  predicate isSink(DataFlow::Node n) { any() }
}

module Flow = DataFlow::Global<Config>;

from DataFlow::Node src, DataFlow::Node sink
where Flow::flow(src, sink)
select src, sink
