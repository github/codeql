import python
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.DataFlow

from DataFlow::Node nodeFrom, DataFlow::Node nodeTo
where TaintTracking::localTaintStep(nodeFrom, nodeTo)
select nodeFrom, nodeTo
