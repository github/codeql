import go

from Type t
where t.getPackage().getName() = ["main", "pkg1", "pkg2"]
select t.pp(), strictcount(t.getMethod(_))
