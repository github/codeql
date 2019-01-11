import DataFlowConfig

class Quelle extends DataFlow::AdditionalSource, DataFlow::ValueNode {
  Quelle() { astNode = any(Variable v | v.getName() = "quelle").getAnAssignedExpr() }

  override predicate isSourceFor(DataFlow::Configuration cfg) {
    cfg instanceof TestDataFlowConfiguration
  }
}

class Abfluss extends DataFlow::AdditionalSink, DataFlow::ValueNode {
  Abfluss() { astNode = any(Variable v | v.getName() = "abfluss").getAnAssignedExpr() }

  override predicate isSinkFor(DataFlow::Configuration cfg) {
    cfg instanceof TestDataFlowConfiguration
  }
}

from TestDataFlowConfiguration tttc, DataFlow::Node src, DataFlow::Node snk
where tttc.hasFlow(src, snk)
select src, snk
