import csharp

from Callable m, Parameter p, Expr v, string value
where
  m.getDeclaringType().hasName("TestDefaultParameters") and
  p = m.getAParameter() and
  v = p.getDefaultValue() and
  p.hasDefaultValue() and
  if exists(v.getValue()) then value = v.getValue() else value = ""
select p, v, value
