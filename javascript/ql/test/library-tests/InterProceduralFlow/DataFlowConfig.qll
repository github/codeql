import javascript

class TestDataFlowConfiguration extends DataFlow::Configuration {
  TestDataFlowConfiguration() { this = "TestDataFlowConfiguration" }

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
