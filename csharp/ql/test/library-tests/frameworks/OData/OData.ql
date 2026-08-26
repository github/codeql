/**
 * @kind path-problem
 */

import csharp
import Taint::PathGraph

module TaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) {
    exists(Parameter p | p = n.asParameter() |
      p.getType().hasFullyQualifiedName("Microsoft.AspNet.OData", "ODataActionParameters")
      or
      p.getType().getUnboundDeclaration().hasFullyQualifiedName("Microsoft.AspNet.OData", "Delta`1")
      or
      p.getType().getUnboundDeclaration().hasFullyQualifiedName("System.Web.Http.OData", "Delta`1")
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall c | c.getArgument(0) = sink.asExpr() and c.getTarget().hasName("Sink"))
  }
}

module Taint = TaintTracking::Global<TaintConfig>;

from Taint::PathNode source, Taint::PathNode sink
where Taint::flowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
