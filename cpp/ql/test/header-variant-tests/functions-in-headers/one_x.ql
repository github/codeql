import cpp

from Variable x, boolean auto
where if x.declaredUsingAutoType() then auto = true else auto = false
select x, x.getName(), auto
