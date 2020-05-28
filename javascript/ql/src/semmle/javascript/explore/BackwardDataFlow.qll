/**
 * Provides machinery for performing backward data-flow exploration.
 *
 * Importing this module effectively makes all data-flow and taint-tracking configurations
 * ignore their `isSource` predicate. Instead, flow is tracked from any _initial node_ (that is,
 * a node without incoming flow) to a sink node. All initial nodes are then treated as source
 * nodes.
 *
 * Data-flow exploration cannot be used with configurations depending on other configurations.
 *
 * NOTE: This library should only be used for debugging and exploration, not in production code.
 * Backward exploration in particular does not scale on non-trivial code bases and hence is of limited
 * usefulness as it stands.
 */

import javascript

private class BackwardExploringConfiguration extends DataFlow::Configuration {
  DataFlow::Configuration cfg;

  BackwardExploringConfiguration() { this = cfg }

  override predicate isSource(DataFlow::Node node) { any() }

  override predicate isSource(DataFlow::Node node, DataFlow::FlowLabel lbl) { any() }

  override predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(DataFlow::PathNode src, DataFlow::PathNode snk | hasFlowPath(src, snk) |
      source = src.getNode() and
      sink = snk.getNode()
    )
  }

  override predicate hasFlowPath(DataFlow::SourcePathNode source, DataFlow::SinkPathNode sink) {
    exists(DataFlow::MidPathNode first |
      source.getConfiguration() = this and
      source.getASuccessor() = first and
      not exists(DataFlow::MidPathNode mid | mid.getASuccessor() = first) and
      first.getASuccessor*() = sink
    )
  }
}
