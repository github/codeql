import go

from DataFlow::Node nd, DataFlow::Node succ
where
  TaintTracking::localTaintStep(nd, succ) and
  // exclude data-flow steps
  not DataFlow::localFlowStep(nd, succ)
select nd, succ
