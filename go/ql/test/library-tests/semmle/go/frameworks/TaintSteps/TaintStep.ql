import go

from DataFlow::Node pred, DataFlow::Node succ
where
  TaintTracking::localTaintStep(pred, succ) and
  not DataFlow::localFlowStep(pred, succ)
select pred, succ
