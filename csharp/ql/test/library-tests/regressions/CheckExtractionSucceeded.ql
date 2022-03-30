import csharp

from MethodCall mc
select mc.getLocation().getStartLine(), mc, mc.getTarget().getParameter(0).getType().toString()
