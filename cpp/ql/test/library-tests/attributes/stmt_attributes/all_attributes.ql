import cpp

from Stmt s, Attribute a
where a = s.getAnAttribute()
select s, a
