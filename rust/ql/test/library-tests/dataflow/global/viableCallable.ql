import codeql.rust.dataflow.internal.DataFlowImpl

query predicate viableCallable(DataFlowCall call, DataFlowCallable callee) {
  RustDataFlow::viableCallable(call) = callee and
  (call.asCall().fromSource() or call.isImplicitDerefCall(_, _, _, _))
}
