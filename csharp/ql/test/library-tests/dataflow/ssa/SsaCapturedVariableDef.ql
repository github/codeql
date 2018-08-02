import csharp

from string inout, Ssa::ExplicitDefinition def, Ssa::Definition targetDef, Call c
where (inout = "in" and def.isCapturedVariableDefinitionFlowIn(targetDef, c))
   or (inout = "out" and def.isCapturedVariableDefinitionFlowOut(targetDef) and targetDef.(Ssa::ImplicitCallDefinition).getCall() = c)
select inout, def.getSourceVariable(), def, targetDef, c
