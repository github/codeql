import javascript
import DataFlowConfig

query predicate dataFlow(DataFlow::Node src, DataFlow::Node snk) { TestFlow::flow(src, snk) }

class Parity extends DataFlow::FlowLabel {
  Parity() { this = "even" or this = "odd" }

  Parity flip() { result != this }
}

module FlowLabelConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowLabel;

  predicate isSource(DataFlow::Node nd, DataFlow::FlowLabel lbl) {
    nd.(DataFlow::CallNode).getCalleeName() = "source" and
    lbl = "even"
  }

  predicate isSink(DataFlow::Node nd, DataFlow::FlowLabel lbl) {
    nd = any(DataFlow::CallNode c | c.getCalleeName() = "sink").getAnArgument() and
    lbl = "even"
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node pred, DataFlow::FlowLabel predLabel, DataFlow::Node succ,
    DataFlow::FlowLabel succLabel
  ) {
    exists(DataFlow::CallNode c | c = succ |
      c.getCalleeName() = "inc" and
      pred = c.getAnArgument() and
      succLabel = predLabel.(Parity).flip()
    )
  }
}

module FlowLabelFlow = DataFlow::GlobalWithState<FlowLabelConfig>;

query predicate flowLabels(FlowLabelFlow::PathNode source, FlowLabelFlow::PathNode sink) {
  FlowLabelFlow::flowPath(source, sink)
}

module TaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    exists(VariableDeclarator vd |
      vd.getBindingPattern().(VarDecl).getName().matches("%source%") and
      src.asExpr() = vd.getInit()
    )
  }

  predicate isSink(DataFlow::Node snk) {
    exists(VariableDeclarator vd |
      vd.getBindingPattern().(VarDecl).getName().matches("%sink%") and
      snk.asExpr() = vd.getInit()
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(Function f |
      f.getName().matches("%noReturnTracking%") and
      node = f.getAReturnedExpr().flow()
    )
    or
    node.asExpr().(PropAccess).getPropertyName() = "notTracked"
  }
}

module TaintFlow = TaintTracking::Global<TaintConfig>;

query predicate taintTracking(DataFlow::Node src, DataFlow::Node snk) { TaintFlow::flow(src, snk) }

module GermanConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    exists(VariableDeclarator vd |
      vd.getBindingPattern().(VarDecl).getName().matches("%source%") and
      src.asExpr() = vd.getInit()
    )
    or
    src.asExpr() = any(Variable v | v.getName() = "quelle").getAnAssignedExpr()
  }

  predicate isSink(DataFlow::Node snk) {
    exists(VariableDeclarator vd |
      vd.getBindingPattern().(VarDecl).getName().matches("%sink%") and
      snk.asExpr() = vd.getInit()
    )
    or
    snk.asExpr() = any(Variable v | v.getName() = "abfluss").getAnAssignedExpr()
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(Function f |
      f.getName().matches("%noReturnTracking%") and
      node = f.getAReturnedExpr().flow()
    )
    or
    node.asExpr().(PropAccess).getPropertyName() = "notTracked"
  }
}

module GermanFlow = DataFlow::Global<GermanConfig>;

query predicate germanFlow(DataFlow::Node src, DataFlow::Node snk) { GermanFlow::flow(src, snk) }
