/**
 * @kind path-problem
 */

import csharp
import utils.test.InlineFlowTest
import PathGraph

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

import ValueFlowTest<TypesConfig>

from PathNode source, PathNode sink
where flowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
