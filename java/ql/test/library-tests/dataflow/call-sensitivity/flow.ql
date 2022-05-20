/**
 * @kind path-problem
 */

import java
import semmle.code.java.dataflow.DataFlow
import DataFlow::PathGraph

class Conf extends DataFlow::Configuration {
  Conf() { this = "CallSensitiveFlowConf" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ClassInstanceExpr }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod().hasName("sink") and
      ma.getAnArgument() = sink.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
