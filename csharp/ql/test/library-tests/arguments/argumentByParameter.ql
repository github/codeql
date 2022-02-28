import csharp

from Call call, Expr arg, Parameter param
where arg = call.getArgumentForParameter(param) and arg.fromSource()
select call, arg, param
