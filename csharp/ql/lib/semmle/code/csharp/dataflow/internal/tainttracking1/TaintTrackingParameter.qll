import semmle.code.csharp.dataflow.internal.TaintTrackingPublic as Public

module Private {
  import semmle.code.csharp.dataflow.DataFlow::DataFlow as DataFlow
  import semmle.code.csharp.dataflow.internal.DataFlowImpl as DataFlowInternal
  import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate
}
