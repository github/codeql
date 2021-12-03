import go

from Type t
where t.getPackage().getName().regexpMatch("main|pkg1|pkg2")
select t.pp(), strictcount(t.getMethod(_))
