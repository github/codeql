import python

from CallNode call, CallableValue callable, string name
select call.getLocation().getStartLine(), call.toString(), callable.toString(), name,
  callable.getNamedArgumentForCall(call, name).toString()
