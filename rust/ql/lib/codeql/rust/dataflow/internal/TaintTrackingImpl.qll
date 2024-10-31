private import rust
private import codeql.dataflow.TaintTracking
private import DataFlowImpl

module RustTaintTracking implements InputSig<Location, RustDataFlow> {
  predicate defaultTaintSanitizer(Node::Node node) { none() }

  /**
   * Holds if the additional step from `src` to `sink` should be included in all
   * global taint flow configurations.
   */
  predicate defaultAdditionalTaintStep(Node::Node src, Node::Node sink, string model) { none() }

  /**
   * Holds if taint flow configurations should allow implicit reads of `c` at sinks
   * and inputs to additional taint steps.
   */
  bindingset[node]
  predicate defaultImplicitTaintRead(Node::Node node, ContentSet c) { none() }

  /**
   * Holds if the additional step from `src` to `sink` should be considered in
   * speculative taint flow exploration.
   */
  predicate speculativeTaintStep(Node::Node src, Node::Node sink) { none() }
}
