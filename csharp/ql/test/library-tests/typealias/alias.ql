import csharp

from Method m, Parameter p, Type t
where
  m.fromSource() and
  p = m.getAParameter() and
  p.getType() = t
select m, p, t.toString()
