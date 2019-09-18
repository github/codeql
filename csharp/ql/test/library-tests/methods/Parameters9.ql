import csharp

from Method m, Parameter p, Expr default
where
  p = m.getAParameter() and
  default = p.getDefaultValue() and
  m.fromSource()
select p, default, m.toStringWithTypes()
