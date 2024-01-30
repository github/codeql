/**
 * @kind path-problem
 */

import csharp
import semmle.code.csharp.dataflow.internal.ExternalFlow
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
 * Emulate that methods with summaries do not have a body.
 * This is relevant for dataflow analysis using summaries with a generated like
 * provenance as generated summaries are only applied, if a
 * callable does not have a body.
 */
private class MethodsWithGeneratedModels extends Method {
  MethodsWithGeneratedModels() {
    this.hasFullyQualifiedName("My.Qltest", "G",
      ["MixedFlowArgs", "GeneratedFlowWithGeneratedNeutral", "GeneratedFlowWithManualNeutral"])
  }

  override predicate hasBody() { none() }
}

from Taint::PathNode source, Taint::PathNode sink
where Taint::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
