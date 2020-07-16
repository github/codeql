import RecordedCalls

import semmle.python.objects.Callables

from ValidRecordedCall rc, Call call, Value calleeValue
where
  call = rc.getCall() and
  calleeValue.getACall() = call.getAFlowNode() and
  (
    rc instanceof RecordedPythonCall and
    calleeValue.(PythonFunctionValue).getScope() = rc.(RecordedPythonCall).getCallee()
    or
    rc instanceof RecordedBuiltinCall and
    calleeValue.(BuiltinFunctionObjectInternal).getBuiltin() = rc.(RecordedBuiltinCall).getCallee()
    or
    rc instanceof RecordedBuiltinCall and
    calleeValue.(BuiltinMethodObjectInternal).getBuiltin() = rc.(RecordedBuiltinCall).getCallee()
  )
select call, "-->", calleeValue
