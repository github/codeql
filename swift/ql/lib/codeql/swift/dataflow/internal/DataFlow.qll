/**
 * Provides an implementation of global (interprocedural) data flow. This file
 * re-exports the local (intraprocedural) data flow analysis from
 * `DataFlowImplSpecific::Public` and adds a global analysis, mainly exposed
 * through the `Global` and `GlobalWithState` modules.
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

  /** Holds if sources should be grouped in the result of `flowPath`. */
  default predicate sourceGrouping(Node source, string sourceGroup) { none() }

  /** Holds if sinks should be grouped in the result of `flowPath`. */
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

  /** Holds if sources should be grouped in the result of `flowPath`. */
  default predicate sourceGrouping(Node source, string sourceGroup) { none() }

  /** Holds if sinks should be grouped in the result of `flowPath`. */
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
 * Gets the exploration limit for `partialFlow` and `partialFlowRev`
 * measured in approximate number of interprocedural steps.
 */
signature int explorationLimitSig();

/**
 * The output of a global data flow computation.
 */
signature module GlobalFlowSig {
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
  predicate flowPath(PathNode source, PathNode sink);

  /**
   * Holds if data can flow from `source` to `sink`.
   */
  predicate flow(Node source, Node sink);

  /**
   * Holds if data can flow from some source to `sink`.
   */
  predicate flowTo(Node sink);

  /**
   * Holds if data can flow from some source to `sink`.
   */
  predicate flowToExpr(DataFlowExpr sink);
}

/**
 * Constructs a standard data flow computation.
 */
module Global<ConfigSig Config> implements GlobalFlowSig {
  private module C implements FullStateConfigSig {
    import DefaultState<Config>
    import Config
  }

  import Impl<C>
}

/** DEPRECATED: Use `Global` instead. */
deprecated module Make<ConfigSig Config> implements GlobalFlowSig {
  import Global<Config>
}

/**
 * Constructs a data flow computation using flow state.
 */
module GlobalWithState<StateConfigSig Config> implements GlobalFlowSig {
  private module C implements FullStateConfigSig {
    import Config
  }

  import Impl<C>
}

/** DEPRECATED: Use `GlobalWithState` instead. */
deprecated module MakeWithState<StateConfigSig Config> implements GlobalFlowSig {
  import GlobalWithState<Config>
}

signature class PathNodeSig {
  /** Gets a textual representation of this element. */
  string toString();

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  );

  /** Gets the underlying `Node`. */
  Node getNode();
}

signature module PathGraphSig<PathNodeSig PathNode> {
  /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
  predicate edges(PathNode a, PathNode b);

  /** Holds if `n` is a node in the graph of data flow path explanations. */
  predicate nodes(PathNode n, string key, string val);

  /**
   * Holds if `(arg, par, ret, out)` forms a subpath-tuple, that is, flow through
   * a subpath between `par` and `ret` with the connecting edges `arg -> par` and
   * `ret -> out` is summarized as the edge `arg -> out`.
   */
  predicate subpaths(PathNode arg, PathNode par, PathNode ret, PathNode out);
}

/**
 * Constructs a `PathGraph` from two `PathGraph`s by disjoint union.
 */
module MergePathGraph<
  PathNodeSig PathNode1, PathNodeSig PathNode2, PathGraphSig<PathNode1> Graph1,
  PathGraphSig<PathNode2> Graph2>
{
  private newtype TPathNode =
    TPathNode1(PathNode1 p) or
    TPathNode2(PathNode2 p)

  /** A node in a graph of path explanations that is formed by disjoint union of the two given graphs. */
  class PathNode extends TPathNode {
    /** Gets this as a projection on the first given `PathGraph`. */
    PathNode1 asPathNode1() { this = TPathNode1(result) }

    /** Gets this as a projection on the second given `PathGraph`. */
    PathNode2 asPathNode2() { this = TPathNode2(result) }

    /** Gets a textual representation of this element. */
    string toString() {
      result = this.asPathNode1().toString() or
      result = this.asPathNode2().toString()
    }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      this.asPathNode1().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) or
      this.asPathNode2().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    /** Gets the underlying `Node`. */
    Node getNode() {
      result = this.asPathNode1().getNode() or
      result = this.asPathNode2().getNode()
    }
  }

  /**
   * Provides the query predicates needed to include a graph in a path-problem query.
   */
  module PathGraph implements PathGraphSig<PathNode> {
    /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
    query predicate edges(PathNode a, PathNode b) {
      Graph1::edges(a.asPathNode1(), b.asPathNode1()) or
      Graph2::edges(a.asPathNode2(), b.asPathNode2())
    }

    /** Holds if `n` is a node in the graph of data flow path explanations. */
    query predicate nodes(PathNode n, string key, string val) {
      Graph1::nodes(n.asPathNode1(), key, val) or
      Graph2::nodes(n.asPathNode2(), key, val)
    }

    /**
     * Holds if `(arg, par, ret, out)` forms a subpath-tuple, that is, flow through
     * a subpath between `par` and `ret` with the connecting edges `arg -> par` and
     * `ret -> out` is summarized as the edge `arg -> out`.
     */
    query predicate subpaths(PathNode arg, PathNode par, PathNode ret, PathNode out) {
      Graph1::subpaths(arg.asPathNode1(), par.asPathNode1(), ret.asPathNode1(), out.asPathNode1()) or
      Graph2::subpaths(arg.asPathNode2(), par.asPathNode2(), ret.asPathNode2(), out.asPathNode2())
    }
  }
}
