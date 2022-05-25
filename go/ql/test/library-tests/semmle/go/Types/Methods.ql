import go

from Type t, string m
where t.getPackage().getName().regexpMatch("main|pkg1|pkg2")
select t.pp(), m, t.getMethod(m)
