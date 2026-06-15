/**
 * Provides machinery for performing forward data-flow exploration.
 *
 * Importing this module effectively makes all data-flow and taint-tracking configurations
 * ignore their `isSink` predicate. Instead, flow is tracked from source nodes as far as
 * possible, until a _terminal node_ (that is, a node without any outgoing flow) is reached.
 * All terminal nodes are then treated as sink nodes.
 *
 * Data-flow exploration cannot be used with configurations depending on other configurations.
 *
 * NOTE: This library should only be used for debugging and exploration, not in production code.
 */
deprecated module;

import javascript

deprecated private class ForwardExploringConfiguration extends DataFlow::Configuration {
  ForwardExploringConfiguration() { this = any(DataFlow::Configuration cfg) }

  override predicate isSink(DataFlow::Node node) { any() }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel lbl) { any() }

  override predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(DataFlow::PathNode src, DataFlow::PathNode snk | this.hasFlowPath(src, snk) |
      source = src.getNode() and
      sink = snk.getNode()
    )
  }

  override predicate hasFlowPath(DataFlow::SourcePathNode source, DataFlow::SinkPathNode sink) {
    exists(DataFlow::MidPathNode last |
      source.getConfiguration() = this and
      source.getASuccessor*() = last and
      not last.getASuccessor() instanceof DataFlow::MidPathNode and
      last.getASuccessor() = sink
    )
  }
}
