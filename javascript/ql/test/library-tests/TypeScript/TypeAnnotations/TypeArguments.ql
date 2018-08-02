import javascript

from InvokeExpr invoke, int n
select invoke, n, invoke.getNumTypeArgument(), invoke.getTypeArgument(n)
