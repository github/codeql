import javascript

from FunctionWithAnalyzedParameters f, SimpleParameter p, Expr arg
where f.argumentPassing(p, arg)
select f, p, arg
