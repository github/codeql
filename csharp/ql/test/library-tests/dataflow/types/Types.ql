/**
 * @kind path-problem
 */

import csharp
import Types::PathGraph

module TypesConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof ObjectCreation or
    src.asExpr() instanceof NullLiteral
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasUndecoratedName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }
}

module Types = DataFlow::Global<TypesConfig>;

from Types::PathNode source, Types::PathNode sink
where Types::flowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
