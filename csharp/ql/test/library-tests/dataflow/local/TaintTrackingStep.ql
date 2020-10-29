import csharp

from DataFlow::Node pred, DataFlow::Node succ
where TaintTracking::localTaintStep(pred, succ)
select pred, succ
