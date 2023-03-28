/**
 * DEPRECATED: Use `Global` and `GlobalWithState` instead.
 *
 * Provides a `Configuration` class backwards-compatible interface to the data
 * flow library.
 */

private import DataFlowImplCommon
private import DataFlowImplSpecific::Private
import DataFlowImplSpecific::Public
private import DataFlowImpl
import DataFlowImplCommonPublic
import FlowStateString

/**
 * A configuration of interprocedural data flow analysis. This defines
 * sources, sinks, and any other configurable aspect of the analysis. Each
 * use of the global data flow library must define its own unique extension
 * of this abstract class. To create a configuration, extend this class with
 * a subclass whose characteristic predicate is a unique singleton string.
 * For example, write
 *
 * ```ql
 * class MyAnalysisConfiguration extends DataFlow::Configuration {
 *   MyAnalysisConfiguration() { this = "MyAnalysisConfiguration" }
 *   // Override `isSource` and `isSink`.
 *   // Optionally override `isBarrier`.
 *   // Optionally override `isAdditionalFlowStep`.
 * }
 * ```
 * Conceptually, this defines a graph where the nodes are `DataFlow::Node`s and
 * the edges are those data-flow steps that preserve the value of the node
 * along with any additional edges defined by `isAdditionalFlowStep`.
 * Specifying nodes in `isBarrier` will remove those nodes from the graph, and
 * specifying nodes in `isBarrierIn` and/or `isBarrierOut` will remove in-going
 * and/or out-going edges from those nodes, respectively.
 *
 * Then, to query whether there is flow between some `source` and `sink`,
 * write
 *
 * ```ql
 * exists(MyAnalysisConfiguration cfg | cfg.hasFlow(source, sink))
 * ```
 *
 * Multiple configurations can coexist, but two classes extending
 * `DataFlow::Configuration` should never depend on each other. One of them
 * should instead depend on a `DataFlow2::Configuration`, a
 * `DataFlow3::Configuration`, or a `DataFlow4::Configuration`.
 */
abstract class Configuration extends string {
  bindingset[this]
  Configuration() { any() }

  /**
   * Holds if `source` is a relevant data flow source.
   */
  predicate isSource(Node source) { none() }

  /**
   * Holds if `source` is a relevant data flow source with the given initial
   * `state`.
   */
  predicate isSource(Node source, FlowState state) { none() }

  /**
   * Holds if `sink` is a relevant data flow sink.
   */
  predicate isSink(Node sink) { none() }

  /**
   * Holds if `sink` is a relevant data flow sink accepting `state`.
   */
  predicate isSink(Node sink, FlowState state) { none() }

  /**
   * Holds if data flow through `node` is prohibited. This completely removes
   * `node` from the data flow graph.
   */
  predicate isBarrier(Node node) { none() }

  /**
   * Holds if data flow through `node` is prohibited when the flow state is
   * `state`.
   */
  predicate isBarrier(Node node, FlowState state) { none() }

  /** Holds if data flow into `node` is prohibited. */
  predicate isBarrierIn(Node node) { none() }

  /** Holds if data flow out of `node` is prohibited. */
  predicate isBarrierOut(Node node) { none() }

  /**
   * DEPRECATED: Use `isBarrier` and `BarrierGuard` module instead.
   *
   * Holds if data flow through nodes guarded by `guard` is prohibited.
   */
  deprecated predicate isBarrierGuard(BarrierGuard guard) { none() }

  /**
   * DEPRECATED: Use `isBarrier` and `BarrierGuard` module instead.
   *
   * Holds if data flow through nodes guarded by `guard` is prohibited when
   * the flow state is `state`
   */
  deprecated predicate isBarrierGuard(BarrierGuard guard, FlowState state) { none() }

  /**
   * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
   */
  predicate isAdditionalFlowStep(Node node1, Node node2) { none() }

  /**
   * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
   * This step is only applicable in `state1` and updates the flow state to `state2`.
   */
  predicate isAdditionalFlowStep(Node node1, FlowState state1, Node node2, FlowState state2) {
    none()
  }

  /**
   * Holds if an arbitrary number of implicit read steps of content `c` may be
   * taken at `node`.
   */
  predicate allowImplicitRead(Node node, ContentSet c) { none() }

  /**
   * Gets the virtual dispatch branching limit when calculating field flow.
   * This can be overridden to a smaller value to improve performance (a
   * value of 0 disables field flow), or a larger value to get more results.
   */
  int fieldFlowBranchLimit() { result = 2 }

  /**
   * Gets a data flow configuration feature to add restrictions to the set of
   * valid flow paths.
   *
   * - `FeatureHasSourceCallContext`:
   *    Assume that sources have some existing call context to disallow
   *    conflicting return-flow directly following the source.
   * - `FeatureHasSinkCallContext`:
   *    Assume that sinks have some existing call context to disallow
   *    conflicting argument-to-parameter flow directly preceding the sink.
   * - `FeatureEqualSourceSinkCallContext`:
   *    Implies both of the above and additionally ensures that the entire flow
   *    path preserves the call context.
   *
   * These features are generally not relevant for typical end-to-end data flow
   * queries, but should only be used for constructing paths that need to
   * somehow be pluggable in another path context.
   */
  FlowFeature getAFeature() { none() }

  /** Holds if sources should be grouped in the result of `hasFlowPath`. */
  predicate sourceGrouping(Node source, string sourceGroup) { none() }

  /** Holds if sinks should be grouped in the result of `hasFlowPath`. */
  predicate sinkGrouping(Node sink, string sinkGroup) { none() }

  /**
   * Holds if data may flow from `source` to `sink` for this configuration.
   */
  predicate hasFlow(Node source, Node sink) { hasFlow(source, sink, this) }

  /**
   * Holds if data may flow from `source` to `sink` for this configuration.
   *
   * The corresponding paths are generated from the end-points and the graph
   * included in the module `PathGraph`.
   */
  predicate hasFlowPath(PathNode source, PathNode sink) { hasFlowPath(source, sink, this) }

  /**
   * Holds if data may flow from some source to `sink` for this configuration.
   */
  predicate hasFlowTo(Node sink) { hasFlowTo(sink, this) }

  /**
   * Holds if data may flow from some source to `sink` for this configuration.
   */
  predicate hasFlowToExpr(DataFlowExpr sink) { this.hasFlowTo(exprNode(sink)) }

  /**
   * DEPRECATED: Use `FlowExploration<explorationLimit>` instead.
   *
   * Gets the exploration limit for `hasPartialFlow` and `hasPartialFlowRev`
   * measured in approximate number of interprocedural steps.
   */
  deprecated int explorationLimit() { none() }

  /**
   * Holds if hidden nodes should be included in the data flow graph.
   *
   * This feature should only be used for debugging or when the data flow graph
   * is not visualized (for example in a `path-problem` query).
   */
  predicate includeHiddenNodes() { none() }
}

/**
 * This class exists to prevent mutual recursion between the user-overridden
 * member predicates of `Configuration` and the rest of the data-flow library.
 * Good performance cannot be guaranteed in the presence of such recursion, so
 * it should be replaced by using more than one copy of the data flow library.
 */
abstract private class ConfigurationRecursionPrevention extends Configuration {
  bindingset[this]
  ConfigurationRecursionPrevention() { any() }

  override predicate hasFlow(Node source, Node sink) {
    strictcount(Node n | this.isSource(n)) < 0
    or
    strictcount(Node n | this.isSource(n, _)) < 0
    or
    strictcount(Node n | this.isSink(n)) < 0
    or
    strictcount(Node n | this.isSink(n, _)) < 0
    or
    strictcount(Node n1, Node n2 | this.isAdditionalFlowStep(n1, n2)) < 0
    or
    strictcount(Node n1, Node n2 | this.isAdditionalFlowStep(n1, _, n2, _)) < 0
    or
    super.hasFlow(source, sink)
  }
}

/** A bridge class to access the deprecated `isBarrierGuard`. */
private class BarrierGuardGuardedNodeBridge extends Unit {
  abstract predicate guardedNode(Node n, Configuration config);

  abstract predicate guardedNode(Node n, FlowState state, Configuration config);
}

private class BarrierGuardGuardedNode extends BarrierGuardGuardedNodeBridge {
  deprecated override predicate guardedNode(Node n, Configuration config) {
    exists(BarrierGuard g |
      config.isBarrierGuard(g) and
      n = g.getAGuardedNode()
    )
  }

  deprecated override predicate guardedNode(Node n, FlowState state, Configuration config) {
    exists(BarrierGuard g |
      config.isBarrierGuard(g, state) and
      n = g.getAGuardedNode()
    )
  }
}

private FlowState relevantState(Configuration config) {
  config.isSource(_, result) or
  config.isSink(_, result) or
  config.isBarrier(_, result) or
  config.isAdditionalFlowStep(_, result, _, _) or
  config.isAdditionalFlowStep(_, _, _, result)
}

private newtype TConfigState =
  TMkConfigState(Configuration config, FlowState state) {
    state = relevantState(config) or state instanceof FlowStateEmpty
  }

private Configuration getConfig(TConfigState state) { state = TMkConfigState(result, _) }

private FlowState getState(TConfigState state) { state = TMkConfigState(_, result) }

private predicate singleConfiguration() { 1 = strictcount(Configuration c) }

private module Config implements FullStateConfigSig {
  class FlowState = TConfigState;

  predicate isSource(Node source, FlowState state) {
    getConfig(state).isSource(source, getState(state))
    or
    getConfig(state).isSource(source) and getState(state) instanceof FlowStateEmpty
  }

  predicate isSink(Node sink, FlowState state) {
    getConfig(state).isSink(sink, getState(state))
    or
    getConfig(state).isSink(sink) and getState(state) instanceof FlowStateEmpty
  }

  predicate isBarrier(Node node) { none() }

  predicate isBarrier(Node node, FlowState state) {
    getConfig(state).isBarrier(node, getState(state)) or
    getConfig(state).isBarrier(node) or
    any(BarrierGuardGuardedNodeBridge b).guardedNode(node, getState(state), getConfig(state)) or
    any(BarrierGuardGuardedNodeBridge b).guardedNode(node, getConfig(state))
  }

  predicate isBarrierIn(Node node) { any(Configuration config).isBarrierIn(node) }

  predicate isBarrierOut(Node node) { any(Configuration config).isBarrierOut(node) }

  predicate isAdditionalFlowStep(Node node1, Node node2) {
    singleConfiguration() and
    any(Configuration config).isAdditionalFlowStep(node1, node2)
  }

  predicate isAdditionalFlowStep(Node node1, FlowState state1, Node node2, FlowState state2) {
    getConfig(state1).isAdditionalFlowStep(node1, getState(state1), node2, getState(state2)) and
    getConfig(state2) = getConfig(state1)
    or
    not singleConfiguration() and
    getConfig(state1).isAdditionalFlowStep(node1, node2) and
    state2 = state1
  }

  predicate allowImplicitRead(Node node, ContentSet c) {
    any(Configuration config).allowImplicitRead(node, c)
  }

  int fieldFlowBranchLimit() { result = min(any(Configuration config).fieldFlowBranchLimit()) }

  FlowFeature getAFeature() { result = any(Configuration config).getAFeature() }

  predicate sourceGrouping(Node source, string sourceGroup) {
    any(Configuration config).sourceGrouping(source, sourceGroup)
  }

  predicate sinkGrouping(Node sink, string sinkGroup) {
    any(Configuration config).sinkGrouping(sink, sinkGroup)
  }

  predicate includeHiddenNodes() { any(Configuration config).includeHiddenNodes() }
}

private import Impl<Config> as I
import I

/**
 * A `Node` augmented with a call context (except for sinks), an access path, and a configuration.
 * Only those `PathNode`s that are reachable from a source, and which can reach a sink, are generated.
 */
class PathNode instanceof I::PathNode {
  /** Gets a textual representation of this element. */
  final string toString() { result = super.toString() }

  /**
   * Gets a textual representation of this element, including a textual
   * representation of the call context.
   */
  final string toStringWithContext() { result = super.toStringWithContext() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  final predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    super.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets the underlying `Node`. */
  final Node getNode() { result = super.getNode() }

  /** Gets the `FlowState` of this node. */
  final FlowState getState() { result = getState(super.getState()) }

  /** Gets the associated configuration. */
  final Configuration getConfiguration() { result = getConfig(super.getState()) }

  /** Gets a successor of this node, if any. */
  final PathNode getASuccessor() { result = super.getASuccessor() }

  /** Holds if this node is a source. */
  final predicate isSource() { super.isSource() }

  /** Holds if this node is a grouping of source nodes. */
  final predicate isSourceGroup(string group) { super.isSourceGroup(group) }

  /** Holds if this node is a grouping of sink nodes. */
  final predicate isSinkGroup(string group) { super.isSinkGroup(group) }
}

private predicate hasFlow(Node source, Node sink, Configuration config) {
  exists(PathNode source0, PathNode sink0 |
    hasFlowPath(source0, sink0, config) and
    source0.getNode() = source and
    sink0.getNode() = sink
  )
}

private predicate hasFlowPath(PathNode source, PathNode sink, Configuration config) {
  flowPath(source, sink) and source.getConfiguration() = config
}

private predicate hasFlowTo(Node sink, Configuration config) { hasFlow(_, sink, config) }

predicate flowsTo = hasFlow/3;
