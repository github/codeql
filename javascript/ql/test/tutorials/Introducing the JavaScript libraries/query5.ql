import javascript

from FunctionExpr fe
where fe.getBody() instanceof Expr
select fe, "Use arrow expressions instead of expression closures."
