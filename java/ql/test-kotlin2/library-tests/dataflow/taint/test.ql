import java
import semmle.code.java.dataflow.TaintTracking

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(MethodCall).getMethod().hasName("taint") }

  predicate isSink(DataFlow::Node n) { n.asExpr().(Argument).getCall().getCallee().hasName("sink") }
}

module Flow = TaintTracking::Global<Config>;

from DataFlow::Node src, DataFlow::Node sink
where Flow::flow(src, sink)
select src, sink
