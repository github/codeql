import RecordedCalls

from ValidRecordedCall rc, Call call, Function callee, CallableValue calleeValue
where
    call = rc.getCall() and
    callee = rc.getCallee() and
    calleeValue.getScope() = callee and
    calleeValue.getACall() = call.getAFlowNode()
select call, "-->", callee
