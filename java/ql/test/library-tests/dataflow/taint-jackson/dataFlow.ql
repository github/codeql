import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:dataflow:jackson" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(MethodAccess).getMethod().hasName("taint")
  }

  override predicate isSink(DataFlow::Node sink) { any() }
}

from DataFlow::Node source, DataFlow::Node sink, Conf config
where config.hasFlow(source, sink)
select sink
