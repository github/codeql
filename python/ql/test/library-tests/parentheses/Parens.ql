import python

from Expr e
where e.isParenthesized()
select e.getLocation().getStartLine(), e.toString()
