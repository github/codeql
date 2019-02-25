import javascript

from DataFlow::MethodCallNode call
select call, call.analyze().ppTypes()
