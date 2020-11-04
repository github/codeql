import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.QueryInjection

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:dataflow:android::flow" }

  override predicate isSource(DataFlow::Node source) {
    exists(VarAccess va, MethodAccess ma |
      source.asExpr() = va and
      va.getVariable().getAnAssignedValue() = ma and
      ma.getMethod().hasName("taint")
    )
  }

  override predicate isSink(DataFlow::Node sink) { not isSource(sink) }
}

from DataFlow::Node source, DataFlow::Node sink, Conf config
where config.hasFlow(source, sink) and sink.getLocation().getFile().getBaseName() = "FlowSteps.java"
select source, sink
