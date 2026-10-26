/**
 * @kind path-problem
 */

import csharp
import utils.test.InlineFlowTest
import PathGraph

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

import TaintFlowTest<TaintConfig>

from PathNode source, PathNode sink
where flowPath(source, sink)
select sink.getNode(), source, sink, "This path depends on an $@.", source.getNode(),
  "ODataParameters value"
