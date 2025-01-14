import go

from DefinedType t
where t.getPackage().getName().matches("%main")
select t, t.getName(), t.getMethod(_)
