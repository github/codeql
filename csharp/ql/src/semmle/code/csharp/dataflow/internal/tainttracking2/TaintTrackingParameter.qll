import semmle.code.csharp.dataflow.internal.TaintTrackingPublic as Public

module Private {
  import semmle.code.csharp.dataflow.DataFlow2::DataFlow2 as DataFlow
  import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate
}
