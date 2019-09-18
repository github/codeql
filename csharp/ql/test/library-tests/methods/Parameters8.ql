import csharp

from Method m, Parameter p
where
  p = m.getAParameter() and
  m.fromSource()
select m, p
