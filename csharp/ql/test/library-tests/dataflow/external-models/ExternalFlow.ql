/**
 * @kind path-problem
 */

import csharp
import semmle.code.csharp.dataflow.ExternalFlow
import Taint::PathGraph
import ModelValidation

module TaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ObjectCreation }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }
}

module Taint = TaintTracking::Global<TaintConfig>;

/**
 * Simulate that methods with summaries are not included in the source code.
 * This is relevant for dataflow analysis using summaries tagged as generated.
 */
private class MyMethod extends Method {
  override predicate fromSource() { none() }
}

from Taint::PathNode source, Taint::PathNode sink
where Taint::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
