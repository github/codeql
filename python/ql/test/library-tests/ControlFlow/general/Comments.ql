import python
private import LegacyPointsTo

from ModuleMetrics m, int n
where n = m.getNumberOfLinesOfComments()
select m.toString(), n
