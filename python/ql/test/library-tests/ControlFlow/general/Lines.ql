import python
private import LegacyPointsTo

from Scope s, int n
where
  exists(FunctionMetrics f | f = s | n = f.getNumberOfLines())
  or
  exists(ModuleMetrics m | m = s | n = m.getNumberOfLines())
select s.toString(), n
