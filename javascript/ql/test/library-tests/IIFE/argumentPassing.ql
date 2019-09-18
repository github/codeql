import semmle.javascript.Expr

from ImmediatelyInvokedFunctionExpr iife, Parameter p, Expr arg
where iife.argumentPassing(p, arg)
select iife, p, arg
