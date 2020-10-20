import csharp

from DataFlow::Node pred, DataFlow::Node succ
where
  TaintTracking::localTaintStep(pred, succ) and
  pred.getLocation().getFile().fromSource()
select pred, succ
