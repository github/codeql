import javascript
import ExampleConfiguration

query predicate isBarrier(ExampleConfiguration cfg, DataFlow::Node n) { cfg.isBarrier(n) }

query predicate isLabeledBarrier(
  ExampleConfiguration cfg, DataFlow::Node n, DataFlow::FlowLabel label
) {
  cfg.isLabeledBarrier(n, label)
}
