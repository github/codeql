import java

from Call call, Callable callable, int argCount, int paramCount
where
  call.getCallee() = callable and
  argCount = count(call.getAnArgument()) and
  paramCount = count(callable.getAParameter()) and
  argCount != paramCount
select "Call should have " + paramCount + " arguments but actually has " + argCount, call, callable
