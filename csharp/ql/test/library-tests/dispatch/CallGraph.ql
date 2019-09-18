import csharp

from Callable caller, Callable callee
where
  caller.calls(callee) and
  callee.fromSource()
select caller, callee
