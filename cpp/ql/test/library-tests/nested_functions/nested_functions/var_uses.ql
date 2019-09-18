import cpp

from Variable v, VariableAccess a
where a = v.getAnAccess()
select v, a.getLocation().toString(), a.getEnclosingFunction()
