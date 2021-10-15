import java
import semmle.code.java.dataflow.DataFlow

class Conf extends DataFlow::Configuration {
  Conf() { this = "conf" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr().(MethodAccess).getMethod().hasName("source")
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
