import go

from DataFlow::Node nd, DataFlow::Node succ
where DataFlow::localFlowStep(nd, succ)
select nd, succ
