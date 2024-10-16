import semmle.code.powershell.dataflow.internal.TaintTrackingPublic as Public

module Private {
  import semmle.code.powershell.dataflow.DataFlow::DataFlow as DataFlow
  import semmle.code.powershell.dataflow.internal.DataFlowImpl as DataFlowInternal
  import semmle.code.powershell.dataflow.internal.TaintTrackingPrivate
}
