import javascript

from StrictEqualityTest eq, DataFlow::AnalyzedNode nd, NullLiteral null
where eq.hasOperands(nd.asExpr(), null) and
      not nd.getAValue().isIndefinite(_) and
      not nd.getAValue() instanceof AbstractNull
select eq, "Spurious null check."
