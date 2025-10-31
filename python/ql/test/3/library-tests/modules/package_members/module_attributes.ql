import python
private import LegacyPointsTo

from ModuleObject m, string name
where not m.isC()
select m.toString(), name, m.getAttribute(name).toString()
