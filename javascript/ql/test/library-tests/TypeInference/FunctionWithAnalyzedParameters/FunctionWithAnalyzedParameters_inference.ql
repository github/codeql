import javascript

from FunctionWithAnalyzedParameters f, SimpleParameter p, AnalyzedVarDef var
where
  f.argumentPassing(p, _) and
  var.getAVariable() = p.getVariable()
select p, var.getAnAssignedValue()
