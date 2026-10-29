import javascript
import DataFlowConfig

query predicate dataFlow(DataFlow::Node src, DataFlow::Node snk) { TestFlow::flow(src, snk) }

module FlowLabelConfig implements DataFlow::StateConfigSig {
  private newtype TFlowState =
    TEven() or
    TOdd()

  class FlowState extends TFlowState {
    string toString() {
      this = TEven() and result = "even"
      or
      this = TOdd() and result = "odd"
    }

    FlowState flip() {
      this = TEven() and result = TOdd()
      or
      this = TOdd() and result = TEven()
    }
  }

  predicate isSource(DataFlow::Node nd, FlowState state) {
    nd.(DataFlow::CallNode).getCalleeName() = "source" and
    state = TEven()
  }

  predicate isSink(DataFlow::Node nd, FlowState state) {
    nd = any(DataFlow::CallNode c | c.getCalleeName() = "sink").getAnArgument() and
    state = TEven()
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    exists(DataFlow::CallNode c | c = node2 |
      c.getCalleeName() = "inc" and
      node1 = c.getAnArgument() and
      state2 = state1.flip()
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
