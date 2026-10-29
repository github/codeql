/**
 * @kind path-problem
 */

import csharp
import GlobalFlow::PathGraph

module GlobalFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().(Expr).getValue() = "tainted" }

  predicate isSink(DataFlow::Node sink) {
    exists(LocalVariable v | sink.asExpr() = v.getInitializer())
  }
}

module GlobalFlow = DataFlow::Global<GlobalFlowConfig>;

from GlobalFlow::PathNode source, GlobalFlow::PathNode sink
where GlobalFlow::flowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
