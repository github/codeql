import javascript

from DataFlow::AdditionalFlowStep step, DataFlow::Node pred, DataFlow::Node succ
where step.step(pred, succ)
select pred, succ
