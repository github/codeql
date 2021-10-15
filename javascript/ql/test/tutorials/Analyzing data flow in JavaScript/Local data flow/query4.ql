import javascript

from DataFlow::SourceNode arg, DataFlow::CallNode call
where
  arg = DataFlow::globalVarRef("process").getAPropertyRead("argv").getAPropertyReference() and
  call = DataFlow::moduleMember("fs", "readFile").getACall() and
  arg.flowsTo(call.getArgument(0))
select arg, call
