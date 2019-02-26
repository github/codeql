import javascript

from DataFlow::Node pred, DataFlow::Node succ
where DataFlow::localFieldStep(pred, succ)
select pred, succ
