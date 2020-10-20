import csharp

from DataFlow::Node pred, DataFlow::Node succ
where
  DataFlow::localFlowStep(pred, succ) and
  pred.getLocation().getFile().fromSource()
select pred, succ
