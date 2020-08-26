import python
import experimental.dataflow.TaintTracking
import experimental.dataflow.DataFlow

from DataFlow::Node nodeFrom, DataFlow::Node nodeTo
where TaintTracking::localTaintStep(nodeFrom, nodeTo)
select nodeFrom, nodeTo
