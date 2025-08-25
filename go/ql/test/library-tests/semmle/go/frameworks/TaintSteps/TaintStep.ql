// This test finds taint tracking steps which are not data flow steps
// to illustrate which steps are added specifically by taint tracking
import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.dataflow.internal.DataFlowPrivate

from DataFlow::Node pred, DataFlow::Node succ
where
  TaintTracking::localTaintStep(pred, succ) and
  not DataFlow::localFlowStep(pred, succ) and
  // Exclude results from libraries
  not pred instanceof FlowSummaryNode
select pred, succ
