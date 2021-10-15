import cpp

from UserType t
where t.getFile().toString() != ""
select t, count(t.getLocation())
