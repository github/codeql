import python
private import semmle.python.controlflow.internal.Cfg as Cfg
private import semmle.python.dataflow.new.internal.DataFlowDispatch as Dispatch

from Call call, Function target, Dispatch::CallType callType
where
  exists(Cfg::CallNode cfgCall |
    cfgCall.getNode() = call and
    Dispatch::resolveCall(cfgCall, target, callType)
  ) and
  call.getLocation().getFile().getRelativePath() = "test.py" and
  target.getLocation().getFile().getRelativePath() = "test.py" and
  (
    call.getFunc().(Name).getId() = "func"
    or
    call.getFunc().(Attribute).getName() = "compile"
  )
select call, target, callType.toString()
