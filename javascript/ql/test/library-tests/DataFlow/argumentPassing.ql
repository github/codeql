import javascript
import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps

from DataFlow::Node invk, DataFlow::Node arg, Function f, DataFlow::SourceNode parm
where FlowSteps::argumentPassing(invk, arg, f, parm)
select invk, arg, f, parm
