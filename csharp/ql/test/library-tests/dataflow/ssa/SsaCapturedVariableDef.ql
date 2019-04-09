import csharp

from string inout, Ssa::ExplicitDefinition def, Ssa::Definition targetDef, ControlFlow::Node call, boolean additionalCalls
where
  inout = "in" and def.isCapturedVariableDefinitionFlowIn(targetDef, call, additionalCalls)
  or
  inout = "out" and
  def.isCapturedVariableDefinitionFlowOut(targetDef, additionalCalls) and
  targetDef.(Ssa::ImplicitCallDefinition).getControlFlowNode() = call
select inout, def.getSourceVariable(), def, targetDef, call, additionalCalls
