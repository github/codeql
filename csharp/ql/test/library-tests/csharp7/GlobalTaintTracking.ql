/**
 * @kind path-problem
 */

import csharp
import Taint::PathGraph

module TaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().(Expr).getValue() = "tainted" }

  predicate isSink(DataFlow::Node sink) {
    exists(LocalVariable v | sink.asExpr() = v.getInitializer())
  }
}

module Taint = TaintTracking::Global<TaintConfig>;

from Taint::PathNode source, Taint::PathNode sink
where Taint::flowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
