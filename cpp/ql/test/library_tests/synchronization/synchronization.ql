import cpp
import testoptions

from FunctionCall call, string s, Expr arg
where
  s = "lockCall" and
  lockCall(arg, call)
  or
  s = "mustlockCall" and
  mustlockCall(arg, call)
  or
  s = "trylockCall" and
  trylockCall(arg, call)
  or
  s = "unlockCall" and
  unlockCall(arg, call)
select call, s, arg
