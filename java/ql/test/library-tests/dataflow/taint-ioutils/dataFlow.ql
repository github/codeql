import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:dataflow:ioutils" }

  override predicate isSource(DataFlow::Node source) { source instanceof UserInput }

  override predicate isSink(DataFlow::Node sink) { any() }
}

from UserInput u, DataFlow::Node e, Conf config
where config.hasFlow(u, e) and e.getEnclosingCallable().hasName("ioutils")
select e
