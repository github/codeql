import javascript

from DataFlow::Node pred, DataFlow::Node succ
where TaintTracking::uriStep(pred, succ)
select pred, succ
