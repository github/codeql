import python

from ModuleObject m, string name
where not m.isC() and m.exports(name)
select m.toString(), name
