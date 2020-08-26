import javascript

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

from TestTaintTrackingConfiguration tttc, DataFlow::Node src, DataFlow::Node snk
where tttc.hasFlow(src, snk)
select src, snk
