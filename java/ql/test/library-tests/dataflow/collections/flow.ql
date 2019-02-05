import java
import semmle.code.java.dataflow.TaintTracking

class Conf extends TaintTracking::Configuration {
  Conf() { this = "conf" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr().(VarAccess).getVariable().hasName("tainted")
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getAnArgument() and
      ma.getMethod().hasName("sink")
    )
  }
}

from Conf c, DataFlow::Node src, DataFlow::Node sink
where c.hasFlow(src, sink)
select src, sink
