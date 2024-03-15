import javascript

module TestConfig implements DataFlow::ConfigSig {
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

module TestFlow = DataFlow::Global<TestConfig>;
