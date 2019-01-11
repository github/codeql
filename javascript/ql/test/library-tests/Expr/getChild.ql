import javascript

from Expr e, int i, Expr child
where child = e.getChild(i)
select e, i, child
