import go

from Type t, string m
where t.getPackage().getName() = ["main", "pkg1", "pkg2"]
select t.pp(), m, t.getMethod(m)
