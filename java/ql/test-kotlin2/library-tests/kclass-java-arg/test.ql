import java

from MethodCall mc, Argument arg
where mc.getMethod().hasName("consume") and arg = mc.getAnArgument()
select mc.getMethod().getName(), arg.getType().getName()
