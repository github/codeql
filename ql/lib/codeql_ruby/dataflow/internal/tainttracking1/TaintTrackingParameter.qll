import codeql_ruby.dataflow.internal.TaintTrackingPublic as Public

module Private {
  import codeql_ruby.DataFlow::DataFlow as DataFlow
  import codeql_ruby.dataflow.internal.TaintTrackingPrivate
}
