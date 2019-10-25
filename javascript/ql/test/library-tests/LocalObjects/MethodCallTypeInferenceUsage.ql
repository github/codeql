import javascript

from DataFlow::MethodCallNode call, DataFlow::Node use
where call.flowsTo(use) and use != call and not exists(use.getASuccessor())
select call, use, use.analyze().getAValue()
