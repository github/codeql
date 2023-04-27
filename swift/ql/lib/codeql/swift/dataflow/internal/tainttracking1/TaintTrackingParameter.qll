import codeql.swift.dataflow.internal.TaintTrackingPublic as Public

module Private {
  import codeql.swift.dataflow.DataFlow::DataFlow as DataFlow
  import codeql.swift.dataflow.internal.DataFlowImpl as DataFlowInternal
  import codeql.swift.dataflow.internal.TaintTrackingPrivate
}
