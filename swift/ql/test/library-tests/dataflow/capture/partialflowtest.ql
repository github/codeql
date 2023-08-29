import swift
import codeql.swift.dataflow.DataFlow

predicate source(StringLiteralExpr label, Expr value) {
  exists(ApplyExpr ae |
    ae.getStaticTarget().hasName(["source(_:_:)", "taint(_:_:)"]) and
    ae.getFile().getBaseName() = "closures.swift"
  |
    ae.getArgument(0).getExpr() = label and
    ae.getArgument(1).getExpr() = value
  )
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { source(n.asExpr(), _) }

  predicate isSink(DataFlow::Node n) { none() }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    source(n1.asExpr(), n2.asExpr())
  }
}

module Flow = DataFlow::Global<Config>;

int explorationLimit() { result = 100 }

module PartialFlow = Flow::FlowExploration<explorationLimit/0>;

from PartialFlow::PartialPathNode src, PartialFlow::PartialPathNode sink
where PartialFlow::partialFlow(src, sink, _)
select src, sink
