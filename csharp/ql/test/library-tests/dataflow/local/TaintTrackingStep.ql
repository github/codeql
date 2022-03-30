import csharp

from DataFlow::Node pred, DataFlow::Node succ
where
  not pred.asExpr().fromLibrary() and
  TaintTracking::localTaintStep(pred, succ)
select pred, succ
