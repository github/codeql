import cpp

from Function f, Type t
where t = f.getType()
select f, t, t.explain()
