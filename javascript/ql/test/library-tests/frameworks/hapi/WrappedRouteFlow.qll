import javascript

module WrappedRouteConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Http::RequestInputAccess }

  predicate isSink(DataFlow::Node sink) {
    sink = DataFlow::globalVarRef("sink").getACall().getArgument(0)
  }
}

module WrappedRouteTaint = TaintTracking::Global<WrappedRouteConfig>;

query predicate test_WrappedRouteFlow(DataFlow::Node source, DataFlow::Node sink) {
  WrappedRouteTaint::flow(source, sink)
}
