import javascript

/**
 * Track all nodes that do not have flow predecessors.
 */
class TrackAllSources extends DataFlow::TrackedNode {
  TrackAllSources() { not exists(getAPredecessor()) }
}

/**
 * A data flow configuration that emulates the flow tracking done by
 * `DataFlow::TrackedNode`.
 */
class AllSourcesTrackingConfig extends DataFlow::Configuration {
  AllSourcesTrackingConfig() { this = "TrackAllTrackedNodes" }

  override predicate isSource(DataFlow::Node src) { src instanceof DataFlow::TrackedNode }

  override predicate isSink(DataFlow::Node snk) { any() }
}

from DataFlow::Node source, DataFlow::Node sink, AllSourcesTrackingConfig cfg, string problem
where
  cfg.hasFlow(source, sink) and
  not source.(DataFlow::TrackedNode).flowsTo(sink) and
  problem = "missing"
  or
  not cfg.hasFlow(source, sink) and
  source.(DataFlow::TrackedNode).flowsTo(sink) and
  problem = "spurious"
select problem, source, sink
