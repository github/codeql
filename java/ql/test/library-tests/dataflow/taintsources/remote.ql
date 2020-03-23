import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources

class Conf extends TaintTracking::Configuration {
  Conf() { this = "remote taint conf" }

  override predicate isSource(DataFlow::Node n) { n instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node n) { any() }
}

from DataFlow::Node src, DataFlow::Node sink, Conf conf
where conf.hasFlow(src, sink)
select src, sink
