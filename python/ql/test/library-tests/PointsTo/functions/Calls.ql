import python

from CallNode call, FunctionObject func, string kind
where
  (
    func.getAMethodCall() = call and kind = "method"
    or
    func.getAFunctionCall() = call and kind = "function"
  ) and
  call.getLocation().getFile().getShortName().matches("odasa%")
select call.getLocation().getStartLine(), call.toString(), func.toString(), kind
