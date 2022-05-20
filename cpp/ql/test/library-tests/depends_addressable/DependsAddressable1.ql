import cpp

from Expr e, Variable v
where varbind(unresolveElement(e), unresolveElement(v))
select e, v
