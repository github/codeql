/**
 * @kind path-problem
 */

import java
import semmle.code.java.dataflow.DataFlow
import Flow::PathGraph

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ClassInstanceExpr }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod().hasName("sink") and
      ma.getAnArgument() = sink.asExpr()
    )
  }
}

module Flow = DataFlow::Global<Config>;

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
