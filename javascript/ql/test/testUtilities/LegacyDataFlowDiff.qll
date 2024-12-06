private import javascript

private signature class LegacyConfigSig {
  predicate hasFlow(DataFlow::Node source, DataFlow::Node sink);
}

module DataFlowDiff<DataFlow::GlobalFlowSig NewFlow, LegacyConfigSig LegacyConfig> {
  query predicate legacyDataFlowDifference(
    DataFlow::Node source, DataFlow::Node sink, string message
  ) {
    NewFlow::flow(source, sink) and
    not any(LegacyConfig cfg).hasFlow(source, sink) and
    message = "only flow with NEW data flow library"
    or
    not NewFlow::flow(source, sink) and
    any(LegacyConfig cfg).hasFlow(source, sink) and
    message = "only flow with OLD data flow library"
  }
}
