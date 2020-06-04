import python

from ImportMemberNode n, ModuleValue v, string name
where n.getModule(name).pointsTo(v)
select n, name, v
