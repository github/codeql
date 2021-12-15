import csharp

from Property p, Expr e, string s
where
  e = p.getExpressionBody() and s = "body"
  or
  e = p.getInitializer() and s = "initializer"
select p, e, s
