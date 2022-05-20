import codeql.ruby.dataflow.internal.TaintTrackingPublic as Public

module Private {
  import codeql.ruby.DataFlow::DataFlow as DataFlow
  import codeql.ruby.dataflow.internal.TaintTrackingPrivate
}
