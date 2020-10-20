import javascript
import ExampleConfiguration

query predicate isBarrier(ExampleConfiguration cfg, DataFlow::Node n) { cfg.isBarrier(n) }

query predicate isLabeledBarrier(
  ExampleConfiguration cfg, DataFlow::Node n, DataFlow::FlowLabel label
) {
  cfg.isLabeledBarrier(n, label)
}

query predicate isSanitizer(ExampleConfiguration cfg, DataFlow::Node n) { cfg.isSanitizer(n) }

query predicate sanitizingGuard(TaintTracking::SanitizerGuardNode g, Expr e, boolean b) {
  g.sanitizes(b, e)
}

query predicate taintedSink(DataFlow::Node source, DataFlow::Node sink) {
  exists(ExampleConfiguration cfg | cfg.hasFlow(source, sink))
}
