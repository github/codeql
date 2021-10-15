/**
 * @kind path-problem
 */

import csharp
import DataFlow::PathGraph

class MyConfiguration extends TaintTracking::Configuration {
  MyConfiguration() { this = "EntityFramework dataflow" }

  override predicate isSource(DataFlow::Node node) { node.asExpr().getValue() = "tainted" }

  override predicate isSink(DataFlow::Node node) {
    node.asExpr() = any(MethodCall c | c.getTarget().hasName("Sink")).getAnArgument()
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, MyConfiguration conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
