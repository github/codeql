import python
private import LegacyPointsTo

from ModuleObject m, string name
where not m.isC() and m.importedAs(name)
select m.toString(), name
