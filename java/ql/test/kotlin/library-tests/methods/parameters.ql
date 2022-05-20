import java

from Method m, Parameter p, int i
where
  m.getParameter(i) = p and
  m.fromSource()
select m, p, i
