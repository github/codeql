import csharp
private import semmle.code.csharp.controlflow.Guards

private predicate outRefDef(DataFlow::ExprNode ne, int outRef) {
  exists(Ssa::ExplicitDefinition def, Parameter outRefParameter |
    outRefParameter.isOutOrRef() and
    ne.getExpr() = def.getADefinition().getSource() and
    def.isLiveOutRefParameterDefinition(outRefParameter) and
    outRef = outRefParameter.getPosition()
  )
}

class Configuration extends DataFlow::Configuration {
  Configuration() { this = "Configuration" }

  override predicate isSource(DataFlow::Node source) { source instanceof DataFlow::ParameterNode }

  override predicate isSink(DataFlow::Node sink) {
    any(Callable c).canReturn(sink.asExpr()) or outRefDef(sink, _)
  }

  override predicate isBarrier(DataFlow::Node node) {
    exists(AbstractValues::NullValue nv | node.(GuardedDataFlowNode).mustHaveValue(nv) |
      nv.isNull()
    )
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
  exists(DataFlow::ExprNode ne, DataFlow::ParameterNode np |
    outRefDef(ne, outRef) and
    np.getParameter() = p and
    c.hasFlow(np, ne)
  )
}
