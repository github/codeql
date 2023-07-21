/**
 * @kind path-problem
 */

import csharp
import ArrayFlow::PathGraph

module ArrayFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ObjectCreation }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasUndecoratedName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }

  int fieldFlowBranchLimit() { result = 100 }
}

module ArrayFlow = DataFlow::Global<ArrayFlowConfig>;

from ArrayFlow::PathNode source, ArrayFlow::PathNode sink
where ArrayFlow::flowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
