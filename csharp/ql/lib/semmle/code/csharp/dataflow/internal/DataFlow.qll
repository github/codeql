/**
 * Provides an implementation of global (interprocedural) data flow. This file
 * re-exports the local (intraprocedural) data flow analysis from
 * `DataFlowImplSpecific::Public` and adds a global analysis, mainly exposed
 * through the `Make` and `MakeWithState` modules.
 */

private import DataFlowImplCommon
private import DataFlowImplSpecific::Private
import DataFlowImplSpecific::Public
import DataFlowImplCommonPublic
private import DataFlowImpl

/** An input configuration for data flow. */
signature module ConfigSig {
  /**
   * Holds if `source` is a relevant data flow source.
   */
  predicate isSource(Node source);

  /**
   * Holds if `sink` is a relevant data flow sink.
   */
  predicate isSink(Node sink);

  /**
   * Holds if data flow through `node` is prohibited. This completely removes
   * `node` from the data flow graph.
   */
  default predicate isBarrier(Node node) { none() }

  /** Holds if data flow into `node` is prohibited. */
  default predicate isBarrierIn(Node node) { none() }

  /** Holds if data flow out of `node` is prohibited. */
  default predicate isBarrierOut(Node node) { none() }

  /**
   * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
   */
  default predicate isAdditionalFlowStep(Node node1, Node node2) { none() }

  /**
   * Holds if an arbitrary number of implicit read steps of content `c` may be
   * taken at `node`.
   */
  default predicate allowImplicitRead(Node node, ContentSet c) { none() }

  /**
   * Gets the virtual dispatch branching limit when calculating field flow.
   * This can be overridden to a smaller value to improve performance (a
   * value of 0 disables field flow), or a larger value to get more results.
   */
  default int fieldFlowBranchLimit() { result = 2 }

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
  default FlowFeature getAFeature() { none() }

  /** Holds if sources should be grouped in the result of `hasFlowPath`. */
  default predicate sourceGrouping(Node source, string sourceGroup) { none() }

  /** Holds if sinks should be grouped in the result of `hasFlowPath`. */
  default predicate sinkGrouping(Node sink, string sinkGroup) { none() }

  /**
   * Holds if hidden nodes should be included in the data flow graph.
   *
   * This feature should only be used for debugging or when the data flow graph
   * is not visualized (as it is in a `path-problem` query).
   */
  default predicate includeHiddenNodes() { none() }
}

/** An input configuration for data flow using flow state. */
signature module StateConfigSig {
  bindingset[this]
  class FlowState;

  /**
   * Holds if `source` is a relevant data flow source with the given initial
   * `state`.
   */
  predicate isSource(Node source, FlowState state);

  /**
   * Holds if `sink` is a relevant data flow sink accepting `state`.
   */
  predicate isSink(Node sink, FlowState state);

  /**
   * Holds if data flow through `node` is prohibited. This completely removes
   * `node` from the data flow graph.
   */
  default predicate isBarrier(Node node) { none() }

  /**
   * Holds if data flow through `node` is prohibited when the flow state is
   * `state`.
   */
  predicate isBarrier(Node node, FlowState state);

  /** Holds if data flow into `node` is prohibited. */
  default predicate isBarrierIn(Node node) { none() }

  /** Holds if data flow out of `node` is prohibited. */
  default predicate isBarrierOut(Node node) { none() }

  /**
   * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
   */
  default predicate isAdditionalFlowStep(Node node1, Node node2) { none() }

  /**
   * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
   * This step is only applicable in `state1` and updates the flow state to `state2`.
   */
  predicate isAdditionalFlowStep(Node node1, FlowState state1, Node node2, FlowState state2);

  /**
   * Holds if an arbitrary number of implicit read steps of content `c` may be
   * taken at `node`.
   */
  default predicate allowImplicitRead(Node node, ContentSet c) { none() }

  /**
   * Gets the virtual dispatch branching limit when calculating field flow.
   * This can be overridden to a smaller value to improve performance (a
   * value of 0 disables field flow), or a larger value to get more results.
   */
  default int fieldFlowBranchLimit() { result = 2 }

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
  default FlowFeature getAFeature() { none() }

  /** Holds if sources should be grouped in the result of `hasFlowPath`. */
  default predicate sourceGrouping(Node source, string sourceGroup) { none() }

  /** Holds if sinks should be grouped in the result of `hasFlowPath`. */
  default predicate sinkGrouping(Node sink, string sinkGroup) { none() }

  /**
   * Holds if hidden nodes should be included in the data flow graph.
   *
   * This feature should only be used for debugging or when the data flow graph
   * is not visualized (as it is in a `path-problem` query).
   */
  default predicate includeHiddenNodes() { none() }
}

/**
 * Gets the exploration limit for `hasPartialFlow` and `hasPartialFlowRev`
 * measured in approximate number of interprocedural steps.
 */
signature int explorationLimitSig();

/**
 * The output of a data flow computation.
 */
signature module DataFlowSig {
  /**
   * A `Node` augmented with a call context (except for sinks) and an access path.
   * Only those `PathNode`s that are reachable from a source, and which can reach a sink, are generated.
   */
  class PathNode;

  /**
   * Holds if data can flow from `source` to `sink`.
   *
   * The corresponding paths are generated from the end-points and the graph
   * included in the module `PathGraph`.
   */
  predicate hasFlowPath(PathNode source, PathNode sink);

  /**
   * Holds if data can flow from `source` to `sink`.
   */
  predicate hasFlow(Node source, Node sink);

  /**
   * Holds if data can flow from some source to `sink`.
   */
  predicate hasFlowTo(Node sink);

  /**
   * Holds if data can flow from some source to `sink`.
   */
  predicate hasFlowToExpr(DataFlowExpr sink);
}

/**
 * Constructs a standard data flow computation.
 */
module Make<ConfigSig Config> implements DataFlowSig {
  private module C implements FullStateConfigSig {
    import DefaultState<Config>
    import Config
  }

  import Impl<C>
}

/**
 * Constructs a data flow computation using flow state.
 */
module MakeWithState<StateConfigSig Config> implements DataFlowSig {
  private module C implements FullStateConfigSig {
    import Config
  }

  import Impl<C>
}
