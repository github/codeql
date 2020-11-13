import java
import semmle.code.java.dataflow.TaintTracking

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:frameworks:guava" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("taint")
  }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

from DataFlow::Node src, DataFlow::Node sink, Conf conf
where conf.hasFlow(src, sink)
select src, sink
