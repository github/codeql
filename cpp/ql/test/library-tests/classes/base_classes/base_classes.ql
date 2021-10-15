import cpp

from Class c, string s
where if exists(c.getABaseClass()) then s = c.getABaseClass().toString() else s = "<none>"
select c, s
