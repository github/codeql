import csharp
import utils.test.ProvenancePathGraph::ShowProvenance<Tt::PathNode, Tt::PathGraph>

module TtConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr().(StringLiteral).getValue() = "tainted" }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasUndecoratedName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }
}

module Tt = TaintTracking::Global<TtConfig>;

from Tt::PathNode source, Tt::PathNode sink
where Tt::flowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
