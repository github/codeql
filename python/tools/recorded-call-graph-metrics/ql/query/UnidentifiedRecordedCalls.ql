import lib.RecordedCalls

from UnidentifiedRecordedCall rc, string reason
where
  not rc instanceof IgnoredRecordedCall and
  (
    not exists(rc.getACall()) and
    reason = "no call"
    or
    count(rc.getACall()) > 1 and
    reason = "more than 1 call"
    or
    not exists(rc.getAPythonCallee()) and
    not exists(rc.getABuiltinCallee()) and
    reason = "no callee"
    or
    count(rc.getAPythonCallee()) > 1 and
    reason = "more than 1 Python callee"
    or
    count(rc.getABuiltinCallee()) > 1 and
    reason = "more than 1 Builtin callee"
  )
select rc, reason
