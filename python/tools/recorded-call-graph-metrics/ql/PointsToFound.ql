import RecordedCalls

from ValidRecordedCall rc, Call call, Function callable, CallableValue callableValue
where
    call = rc.getCall() and
    callable = rc.getCallable() and
    callableValue.getScope() = callable and
    callableValue.getACall() = call.getAFlowNode()
select call, "-->", callable
