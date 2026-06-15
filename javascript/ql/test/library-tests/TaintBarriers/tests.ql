import javascript
import ExampleConfiguration

deprecated query predicate isBarrier(ExampleConfiguration cfg, DataFlow::Node n) {
  cfg.isBarrier(n)
}

deprecated query predicate isLabeledBarrier(
  ExampleConfiguration cfg, DataFlow::Node n, DataFlow::FlowLabel label
) {
  cfg.isLabeledBarrier(n, label)
}

deprecated query predicate isSanitizer(ExampleConfiguration cfg, DataFlow::Node n) {
  cfg.isSanitizer(n)
}

deprecated query predicate sanitizingGuard(DataFlow::Node g, Expr e, boolean b) {
  g.(TaintTracking::SanitizerGuardNode).sanitizes(b, e)
  or
  g.(TaintTracking::AdditionalSanitizerGuardNode).sanitizes(b, e)
}

query predicate taintedSink(DataFlow::Node source, DataFlow::Node sink) {
  TestFlow::flow(source, sink)
}

deprecated import utils.test.LegacyDataFlowDiff::DataFlowDiff<TestFlow, ExampleConfiguration>
