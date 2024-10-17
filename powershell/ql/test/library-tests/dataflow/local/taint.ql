import powershell
import semmle.code.powershell.dataflow.TaintTracking
import semmle.code.powershell.dataflow.DataFlow

from DataFlow::Node pred, DataFlow::Node succ
where TaintTracking::localTaintStep(pred, succ)
select pred, succ