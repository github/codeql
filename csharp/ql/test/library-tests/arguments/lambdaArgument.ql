import csharp

from Call call, Parameter p, Expr arg
where
  call.getARuntimeTarget() instanceof LambdaExpr and
  arg = call.getRuntimeArgumentForParameter(p)
select call, p, arg
