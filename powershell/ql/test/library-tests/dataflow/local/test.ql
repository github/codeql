import powershell
import semmle.code.powershell.dataflow.DataFlow

from DataFlow::Node pred, DataFlow::Node succ
where DataFlow::localFlowStep(pred, succ)
select pred, succ