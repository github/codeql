/**
 * @kind path-problem
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow::DataFlow
import PathGraph

class Config extends Configuration {
  Config() { this = "Config" }

  override predicate isSource(Node source) {
    source.asExpr() = any(Call c | c.getTarget().hasName("source"))
  }

  override predicate isSink(Node sink) {
    sink.asExpr() = any(Call c | c.getTarget().hasName("sink")).getAnArgument()
  }
}

from PathNode source, PathNode sink, Config config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, ""
