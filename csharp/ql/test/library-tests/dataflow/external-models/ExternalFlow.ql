/**
 * @kind path-problem
 */

import csharp
import DataFlow::PathGraph
import semmle.code.csharp.dataflow.ExternalFlow
import ModelValidation

class Conf extends TaintTracking::Configuration {
  Conf() { this = "ExternalFlow" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ObjectCreation }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }
}

/**
 * Simulate that methods with summaries are not included in the source code.
 * This is relevant for dataflow analysis using summaries tagged as generated.
 */
private class MyMethod extends Method {
  override predicate fromSource() { none() }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
