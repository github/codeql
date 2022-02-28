import csharp

from Call call, Expr arg, string paramName
where arg = call.getArgumentForName(paramName) and arg.fromSource()
select call, arg, paramName
