import codeql.ruby.dataflow.internal.TaintTrackingPublic as Public

module Private {
  import codeql.ruby.dataflow.internal.DataFlowImplForRegExp as DataFlow
  import codeql.ruby.dataflow.internal.TaintTrackingPrivate
}
