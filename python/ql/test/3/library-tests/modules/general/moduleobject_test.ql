import python
private import LegacyPointsTo

from ModuleObject m, string name
where not m.isC() and not m.getName() = "__future__"
select m.toString(), name, m.getAttribute(name).toString()
