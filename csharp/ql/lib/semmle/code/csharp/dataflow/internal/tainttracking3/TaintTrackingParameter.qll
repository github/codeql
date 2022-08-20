import semmle.code.csharp.dataflow.internal.TaintTrackingPublic as Public

module Private {
  import semmle.code.csharp.dataflow.DataFlow3::DataFlow3 as DataFlow
  import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate
}
