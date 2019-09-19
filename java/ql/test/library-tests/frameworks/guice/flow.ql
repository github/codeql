import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

class Conf extends TaintTracking::Configuration {
  Conf() { this = "conf" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getAnArgument() and
      ma.getMethod().hasName("sink")
    ) and
    sink.asExpr().getFile().getStem() = "GuiceRequestParameters"
  }
}

from Conf c, DataFlow::Node src, DataFlow::Node sink
where c.hasFlow(src, sink)
select src, sink
