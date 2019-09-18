import semmle.javascript.Util

from Expr e
select e, describeExpression(e)
