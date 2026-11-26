import go

from DefinedType t
where t.getPackage().getName().endsWith("main")
select t, t.getName(), t.getMethod(_)
