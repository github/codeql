import javascript

from Vue::InstanceHeapStep step, DataFlow::Node pred, DataFlow::Node succ
where step.step(pred, succ)
select step, pred, succ
