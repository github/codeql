import javascript

from DataFlow::InvokeNode call
select call.getCalleeNode(), call.getCalleeNode().analyze().getAValue()
