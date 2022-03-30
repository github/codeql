import csharp

from DataFlow::Node pred, DataFlow::Node succ
where not pred.asExpr().fromLibrary() and DataFlow::localFlowStep(pred, succ)
select pred, succ
