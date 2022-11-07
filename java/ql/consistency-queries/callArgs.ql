import java

from Call call, Callable c
where
  count(call.getAnArgument()) != c.getNumberOfParameters() and
  call.getCallee() = c and
  not exists(Parameter p | c.getAParameter() = p and p.isVarargs()) and
  call.getFile().isKotlinSourceFile()
select call, c, count(call.getAnArgument()), c.getNumberOfParameters()
