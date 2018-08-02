import csharp

from Call call, Expr arg, Parameter param
where arg = call.getArgumentForParameter(param)
select call, arg, param
