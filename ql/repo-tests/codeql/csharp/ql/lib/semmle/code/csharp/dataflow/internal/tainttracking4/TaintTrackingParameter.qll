import semmle.code.csharp.dataflow.internal.TaintTrackingPublic as Public

module Private {
  import semmle.code.csharp.dataflow.DataFlow4::DataFlow4 as DataFlow
  import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate
}
