import semmle.python.dataflow.new.internal_pt.TaintTrackingPublic as Public

module Private {
  import semmle.python.dataflow.new.internal_pt.DataFlowPublic as DataFlow::DataFlow as DataFlow
  import semmle.python.dataflow.new.internal_pt.TaintTrackingPrivate
}
