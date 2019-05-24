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

  override predicate isSanitizerEdge(DataFlow::Node src, DataFlow::Node snk) {
    src = src and
    snk.asExpr().(PropAccess).getPropertyName() = "notTracked"
    or
    exists(Function f |
      f.getName().matches("%noReturnTracking%") and
      src = f.getAReturnedExpr().flow() and
      snk.(DataFlow::InvokeNode).getACallee() = f
    )
  }
}

from TestTaintTrackingConfiguration tttc, DataFlow::Node src, DataFlow::Node snk
where tttc.hasFlow(src, snk)
select src, snk
