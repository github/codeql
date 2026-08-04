/**
 * @kind path-problem
 */

import csharp
import semmle.code.csharp.dataflow.internal.DataFlowPrivate as DataFlowPrivate
import Taint::PathGraph

module TaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    exists(MethodCall mc |
      mc.getTarget().hasName("TaintArgument") and
      mc.getAnArgument() = src.(DataFlowPrivate::PostUpdateNode).getPreUpdateNode().asExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }
}

module Taint = TaintTracking::Global<TaintConfig>;

from Taint::PathNode source, Taint::PathNode sink
where Taint::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
