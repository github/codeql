import javascript
import semmle.javascript.dataflow.internal.FlowSteps

from DataFlow::InvokeNode node, Function callee
where calls(node, callee)
select node, callee, 0
