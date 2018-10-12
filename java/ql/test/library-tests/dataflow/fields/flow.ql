import java
import semmle.code.java.dataflow.DataFlow

class Conf extends DataFlow::Configuration {
  Conf() { this = "FieldFlowConf" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ClassInstanceExpr }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod().hasName("sink") and
      ma.getAnArgument() = sink.asExpr()
    )
  }
}

from DataFlow::Node src, DataFlow::Node sink, Conf conf
where conf.hasFlow(src, sink)
select src, sink
