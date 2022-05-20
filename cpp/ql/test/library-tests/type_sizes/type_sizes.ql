import cpp

from Type t, string s
where if exists(t.getSize().toString()) then s = t.getSize().toString() else s = "<none>"
select t, s
