import go

from DataFlow::Node nd, DataFlow::Node succ
where
  DataFlow::localFlowStep(nd, succ) and
  (exists(nd.getFile()) or exists(succ.getFile()))
select nd, succ
