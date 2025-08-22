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

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof DataFlow::ParameterNode }

  predicate isSink(DataFlow::Node sink) {
    any(Callable c).canReturn(sink.asExpr()) or outRefDef(sink, _)
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(AbstractValues::NullValue nv | node.(GuardedDataFlowNode).mustHaveValue(nv) |
      nv.isNull()
    )
  }
}

module FlowOut<DataFlow::GlobalFlowSig Input> {
  predicate flowOutFromParameter(Parameter p) {
    exists(DataFlow::ExprNode ne, DataFlow::ParameterNode np |
      p.getCallable().canReturn(ne.getExpr()) and
      np.getParameter() = p and
      Input::flow(np, ne)
    )
  }

  predicate flowOutFromParameterOutOrRef(Parameter p, int outRef) {
    exists(DataFlow::ExprNode ne, DataFlow::ParameterNode np |
      outRefDef(ne, outRef) and
      np.getParameter() = p and
      Input::flow(np, ne)
    )
  }
}

module Data = FlowOut<DataFlow::Global<Config>>;

module Taint = FlowOut<TaintTracking::Global<Config>>;
