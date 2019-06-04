import csharp

from Case c, Expr e
where
  e = c.getPattern().stripCasts() and
  (e instanceof @unknown_expr or e instanceof ConstantPatternExpr)
select c, e
