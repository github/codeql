import DataFlowConfig

query predicate dataFlow(DataFlow::Node src, DataFlow::Node snk) {
  exists(TestDataFlowConfiguration tttc | tttc.hasFlow(src, snk))
}

class Parity extends DataFlow::FlowLabel {
  Parity() { this = "even" or this = "odd" }

  Parity flip() { result != this }
}

class FLowLabelConfig extends DataFlow::Configuration {
  FLowLabelConfig() { this = "FLowLabelConfig" }

  override predicate isSource(DataFlow::Node nd, DataFlow::FlowLabel lbl) {
    nd.(DataFlow::CallNode).getCalleeName() = "source" and
    lbl = "even"
  }

  override predicate isSink(DataFlow::Node nd, DataFlow::FlowLabel lbl) {
    nd = any(DataFlow::CallNode c | c.getCalleeName() = "sink").getAnArgument() and
    lbl = "even"
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel predLabel,
    DataFlow::FlowLabel succLabel
  ) {
    exists(DataFlow::CallNode c | c = succ |
      c.getCalleeName() = "inc" and
      pred = c.getAnArgument() and
      succLabel = predLabel.(Parity).flip()
    )
  }
}

query predicate flowLabels(DataFlow::PathNode source, DataFlow::PathNode sink) {
  exists(FLowLabelConfig cfg | cfg.hasFlowPath(source, sink))
}

class TestTaintTrackingConfiguration extends TaintTracking::Configuration {
  TestTaintTrackingConfiguration() { this = "TestTaintTrackingConfiguration" }

  override predicate isSource(DataFlow::Node src) {
    exists(VariableDeclarator vd |
      vd.getBindingPattern().(VarDecl).getName().matches("%source%") and
      src.asExpr() = vd.getInit()
    )
  }

  override predicate isSink(DataFlow::Node snk) {
    exists(VariableDeclarator vd |
      vd.getBindingPattern().(VarDecl).getName().matches("%sink%") and
      snk.asExpr() = vd.getInit()
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(Function f |
      f.getName().matches("%noReturnTracking%") and
      node = f.getAReturnedExpr().flow()
    )
  }

  override predicate isSanitizerEdge(DataFlow::Node src, DataFlow::Node snk) {
    src = src and
    snk.asExpr().(PropAccess).getPropertyName() = "notTracked"
  }
}

query predicate taintTracking(DataFlow::Node src, DataFlow::Node snk) {
  exists(TestTaintTrackingConfiguration tttc | tttc.hasFlow(src, snk))
}

class GermanFlowConfig extends DataFlow::Configuration {
  GermanFlowConfig() { this = "GermanFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    exists(VariableDeclarator vd |
      vd.getBindingPattern().(VarDecl).getName().matches("%source%") and
      src.asExpr() = vd.getInit()
    )
    or
    src.asExpr() = any(Variable v | v.getName() = "quelle").getAnAssignedExpr()
  }

  override predicate isSink(DataFlow::Node snk) {
    exists(VariableDeclarator vd |
      vd.getBindingPattern().(VarDecl).getName().matches("%sink%") and
      snk.asExpr() = vd.getInit()
    )
    or
    snk.asExpr() = any(Variable v | v.getName() = "abfluss").getAnAssignedExpr()
  }

  override predicate isBarrier(DataFlow::Node node) {
    exists(Function f |
      f.getName().matches("%noReturnTracking%") and
      node = f.getAReturnedExpr().flow()
    )
  }

  override predicate isBarrierEdge(DataFlow::Node src, DataFlow::Node snk) {
    src = src and
    snk.asExpr().(PropAccess).getPropertyName() = "notTracked"
  }
}

query predicate germanFlow(DataFlow::Node src, DataFlow::Node snk) {
  exists(GermanFlowConfig tttc | tttc.hasFlow(src, snk))
}
