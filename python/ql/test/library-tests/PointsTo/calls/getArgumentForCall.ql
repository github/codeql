import python

from CallNode call, CallableValue callable, int i
select call.getLocation().getStartLine(), call.toString(), callable.toString(), i,
  callable.getArgumentForCall(call, i).toString()
