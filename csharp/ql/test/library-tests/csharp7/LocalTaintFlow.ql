import csharp

from DataFlow::Node pred, DataFlow::Node succ
where
  TaintTracking::localTaintStep(pred, succ) and
  not pred.asExpr().fromLibrary()
select pred, succ
