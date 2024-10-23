/**
 * @kind path-problem
 */

import csharp
import semmle.code.csharp.dataflow.internal.ExternalFlow
// import TestUtilities.ProvenancePathGraph::ShowProvenance<Taint::PathNode, Taint::PathGraph>
import semmle.code.csharp.security.dataflow.flowsources.Remote
private import semmle.code.csharp.frameworks.microsoft.Blazor as Blazor

module TaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    Blazor::Helpers::isOutflowSource(_, source.asParameter())
  }

  predicate isSink(DataFlow::Node sink) {
    // todo: this could be any access that's assigned to component properties.
    sink.asExpr() instanceof Access
  }

  predicate includeHiddenNodes() { any() }
}

module Taint = TaintTracking::Global<TaintConfig>;

from Taint::PathNode source, Taint::PathNode sink
where Taint::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
