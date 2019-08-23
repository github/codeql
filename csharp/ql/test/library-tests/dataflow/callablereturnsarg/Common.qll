import csharp
private import DataFlow::BarrierGuards

private class AntiNullBarrierGuard extends ValueBarrierGuard {
  AntiNullBarrierGuard() { val.(NullValue).isNull() }
}

class Configuration extends DataFlow::Configuration {
  Configuration() { this = "Configuration" }

  override predicate isSource(DataFlow::Node source) { any() }

  override predicate isSink(DataFlow::Node sink) { any() }

  override predicate isBarrierGuard(DataFlow::BarrierGuard guard) {
    guard instanceof AntiNullBarrierGuard
  }
}

predicate flowOutFromParameter(DataFlow::Configuration c, Parameter p) {
  exists(DataFlow::ExprNode ne, DataFlow::ParameterNode np |
    p.getCallable().canReturn(ne.getExpr()) and
    np.getParameter() = p and
    c.hasFlow(np, ne)
  )
}

predicate flowOutFromParameterOutOrRef(DataFlow::Configuration c, Parameter p, int outRef) {
  exists(
    DataFlow::ExprNode ne, Ssa::ExplicitDefinition def, DataFlow::ParameterNode np,
    Parameter outRefParameter
  |
    outRefParameter.isOutOrRef() and
    np.getParameter() = p and
    ne.getExpr() = def.getADefinition().getSource() and
    def.isLiveOutRefParameterDefinition(outRefParameter) and
    c.hasFlow(np, ne) and
    outRef = outRefParameter.getPosition()
  )
}
