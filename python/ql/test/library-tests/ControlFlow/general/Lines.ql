import python

from Scope s, int n
where
  exists(Function f | f = s | n = f.getMetrics().getNumberOfLines())
  or
  exists(Module m | m = s | n = m.getMetrics().getNumberOfLines())
select s.toString(), n
