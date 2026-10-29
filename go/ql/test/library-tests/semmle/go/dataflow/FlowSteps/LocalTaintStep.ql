import go
import semmle.go.dataflow.internal.DataFlowPrivate

from DataFlow::Node nd, DataFlow::Node succ
where
  TaintTracking::localTaintStep(nd, succ) and
  // exclude data-flow steps
  not DataFlow::localFlowStep(nd, succ) and
  // Exclude results from libraries
  not nd instanceof FlowSummaryNode
select nd, succ
