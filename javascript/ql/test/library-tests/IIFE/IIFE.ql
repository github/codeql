import semmle.javascript.Expr

from ImmediatelyInvokedFunctionExpr iife
select iife, iife.getInvocation()
