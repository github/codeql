import javascript

class PrototypePollConfiguration extends TaintTracking::Configuration {
  PrototypePollConfiguration() { this = "PrototypePollConfiguration" }

  override predicate isSource(DataFlow::Node source) {
      // Source identification
      none()
  }

  override predicate isSink(DataFlow::Node sink) {
      // Sink identification
      none()
  }
}

from PrototypePollConfiguration cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select source, sink
