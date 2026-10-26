import csharp

from Call call, Expr arg, string paramName
where arg = call.getArgumentForName(paramName)
select call, arg, paramName
