import cpp

from AssignExpr e, int i
where exists(e.getChild(i))
select e, i
