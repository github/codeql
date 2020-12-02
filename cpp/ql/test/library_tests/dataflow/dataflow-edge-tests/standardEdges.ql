import cpp
import semmle.code.cpp.dataflow.DataFlow

from DataFlow::Node nodeFrom, DataFlow::Node nodeTo
where DataFlow::localFlowStep(nodeFrom, nodeTo)
select nodeFrom, nodeTo
