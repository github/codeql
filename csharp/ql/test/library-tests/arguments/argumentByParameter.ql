import csharp

from Call call, Expr arg, Parameter param
where
  arg = call.getArgumentForParameter(param) and
  call.getTarget().fromSource()
select call, arg, param
