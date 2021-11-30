import java

from Method m, int i, Parameter p
where m.getName().matches("foo%")
  and p = m.getParameter(i)
select m, m.getReturnType(), i, p, p.getType()

