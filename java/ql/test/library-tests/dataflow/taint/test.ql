import java
import semmle.code.java.dataflow.TaintTracking

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qqconf" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("taint")
  }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().hasName("sink")
  }
}

from DataFlow::Node src, DataFlow::Node sink, Conf conf
where conf.hasFlow(src, sink)
select src, sink
