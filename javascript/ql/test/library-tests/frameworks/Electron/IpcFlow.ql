import javascript

from DataFlow::AdditionalFlowStep afs, DataFlow::Node pred, DataFlow::Node succ
where afs.step(pred, succ)
select pred, succ
