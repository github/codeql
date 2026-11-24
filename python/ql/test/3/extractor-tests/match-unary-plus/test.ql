import python

from UnaryExpr expr
where expr.getLocation().getFile().getShortName() = "test.py"
select expr, expr.getOp().toString()
