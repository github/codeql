/**
 * Provides an implementation of global (interprocedural) data flow. This file
 * adds a global analysis, mainly exposed through the `Global` and `GlobalWithState`
 * modules.
 */

/** Provides language-specific data flow parameters. */
signature module InputSig {
  class Node {
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
  }

  class ParameterNode extends Node;

  class ArgumentNode extends Node;

  class ReturnNode extends Node {
    ReturnKind getKind();
  }

  class OutNode extends Node;

  class PostUpdateNode extends Node {
    Node getPreUpdateNode();
  }

  class CastNode extends Node;

  predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos);

  predicate isArgumentNode(ArgumentNode n, DataFlowCall call, ArgumentPosition pos);

  DataFlowCallable nodeGetEnclosingCallable(Node node);

  DataFlowType getNodeType(Node node);

  predicate nodeIsHidden(Node node);

  class DataFlowExpr;

  /** Gets the node corresponding to `e`. */
  Node exprNode(DataFlowExpr e);

  class DataFlowCall {
    /** Gets a textual representation of this element. */
    string toString();

    DataFlowCallable getEnclosingCallable();
  }

  class DataFlowCallable {
    /** Gets a textual representation of this element. */
    string toString();
  }

  class ReturnKind {
    /** Gets a textual representation of this element. */
    string toString();
  }

  /** Gets a viable implementation of the target of the given `Call`. */
  DataFlowCallable viableCallable(DataFlowCall c);

  /**
   * Holds if the set of viable implementations that can be called by `call`
   * might be improved by knowing the call context.
   */
  default predicate mayBenefitFromCallContext(DataFlowCall call) { none() }

  /**
   * Gets a viable dispatch target of `call` in the context `ctx`. This is
   * restricted to those `call`s for which a context might make a difference.
   */
  default DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) { none() }

  /**
   * Gets a node that can read the value returned from `call` with return kind
   * `kind`.
   */
  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind);

  /**
   * A type for a data flow node.
   *
   * This may or may not coincide with any type system existing for the source
   * language, but should minimally include unique types for individual closure
   * expressions (typically lambdas).
   */
  class DataFlowType {
    /** Gets a textual representation of this element. */
    string toString();
  }

  string ppReprType(DataFlowType t);

  /**
   * Holds if `t1` and `t2` are compatible types.
   *
   * This predicate must be symmetric and reflexive.
   *
   * This predicate is used in the following way: If the data flow library
   * tracks an object from node `n1` to `n2` using solely value-preserving
   * steps, then it will check that the types of `n1` and `n2` are compatible.
   * If they are not, then flow will be blocked.
   */
  bindingset[t1, t2]
  predicate compatibleTypes(DataFlowType t1, DataFlowType t2);

  /**
   * Holds if `t1` is strictly stronger than `t2`. That is, `t1` is a strict
   * subtype of `t2`.
   *
   * This predicate must be transitive and imply `compatibleTypes(t1, t2)`.
   */
  predicate typeStrongerThan(DataFlowType t1, DataFlowType t2);

  class Content {
    /** Gets a textual representation of this element. */
    string toString();
  }

  predicate forceHighPrecision(Content c);

  /**
   * An entity that represents a set of `Content`s.
   *
   * The set may be interpreted differently depending on whether it is
   * stored into (`getAStoreContent`) or read from (`getAReadContent`).
   */
  class ContentSet {
    /** Gets a textual representation of this element. */
    string toString();

    /** Gets a content that may be stored into when storing into this set. */
    Content getAStoreContent();

    /** Gets a content that may be read from when reading from this set. */
    Content getAReadContent();
  }

  class ContentApprox {
    /** Gets a textual representation of this element. */
    string toString();
  }

  ContentApprox getContentApprox(Content c);

  class ParameterPosition {
    /** Gets a textual representation of this element. */
    bindingset[this]
    string toString();
  }

  class ArgumentPosition {
    /** Gets a textual representation of this element. */
    bindingset[this]
    string toString();
  }

  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos);

  predicate simpleLocalFlowStep(Node node1, Node node2);

  /**
   * Holds if the data-flow step from `node1` to `node2` can be used to
   * determine where side-effects may return from a callable.
   */
  bindingset[node1, node2]
  default predicate validParameterAliasStep(Node node1, Node node2) { any() }

  /**
   * Holds if data can flow from `node1` to `node2` through a non-local step
   * that does not follow a call edge. For example, a step through a global
   * variable.
   */
  predicate jumpStep(Node node1, Node node2);

  /**
   * Holds if data can flow from `node1` to `node2` via a read of `c`.  Thus,
   * `node1` references an object with a content `c.getAReadContent()` whose
   * value ends up in `node2`.
   */
  predicate readStep(Node node1, ContentSet c, Node node2);

  /**
   * Holds if data can flow from `node1` to `node2` via a store into `c`.  Thus,
   * `node2` references an object with a content `c.getAStoreContent()` that
   * contains the value of `node1`.
   */
  predicate storeStep(Node node1, ContentSet c, Node node2);

  /**
   * Holds if values stored inside content `c` are cleared at node `n`. For example,
   * any value stored inside `f` is cleared at the pre-update node associated with `x`
   * in `x.f = newValue`.
   */
  predicate clearsContent(Node n, ContentSet c);

  /**
   * Holds if the value that is being tracked is expected to be stored inside content `c`
   * at node `n`.
   */
  predicate expectsContent(Node n, ContentSet c);

  /**
   * Holds if the node `n` is unreachable when the call context is `call`.
   */
  predicate isUnreachableInCall(Node n, DataFlowCall call);

  default int accessPathLimit() { result = 5 }

  /**
   * Holds if flow is allowed to pass from parameter `p` and back to itself as a
   * side-effect, resulting in a summary from `p` to itself.
   *
   * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
   * by default as a heuristic.
   */
  predicate allowParameterReturnInSelf(ParameterNode p);

  /**
   * Holds if the value of `node2` is given by `node1`.
   *
   * This predicate is combined with type information in the following way: If
   * the data flow library is able to compute an improved type for `node1` then
   * it will also conclude that this type applies to `node2`. Vice versa, if
   * `node2` must be visited along a flow path, then any type known for `node2`
   * must also apply to `node1`.
   */
  predicate localMustFlowStep(Node node1, Node node2);

  class LambdaCallKind;

  /** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
  predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c);

  /** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
  predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver);

  /** Extra data-flow steps needed for lambda flow analysis. */
  predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue);

  /**
   * Holds if `n` should never be skipped over in the `PathGraph` and in path
   * explanations.
   */
  default predicate neverSkipInPathGraph(Node n) { none() }

  /**
   * Gets an additional term that is added to the `join` and `branch` computations to reflect
   * an additional forward or backwards branching factor that is not taken into account
   * when calculating the (virtual) dispatch cost.
   *
   * Argument `arg` is part of a path from a source to a sink, and `p` is the target parameter.
   */
  default int getAdditionalFlowIntoCallNodeTerm(ArgumentNode arg, ParameterNode p) { none() }

  bindingset[call, p, arg]
  default predicate golangSpecificParamArgFilter(
    DataFlowCall call, ParameterNode p, ArgumentNode arg
  ) {
    any()
  }
}

module Configs<InputSig Lang> {
  private import Lang
  private import internal.DataFlowImplCommon::MakeImplCommon<Lang>
  import DataFlowImplCommonPublic

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
     * Holds if `node` should never be skipped over in the `PathGraph` and in path
     * explanations.
     */
    default predicate neverSkip(Node node) {
      isAdditionalFlowStep(node, _) or isAdditionalFlowStep(_, node)
    }

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
     * Holds if `sink` is a relevant data flow sink for any state.
     */
    default predicate isSink(Node sink) { none() }

    /**
     * Holds if data flow through `node` is prohibited. This completely removes
     * `node` from the data flow graph.
     */
    default predicate isBarrier(Node node) { none() }

    /**
     * Holds if data flow through `node` is prohibited when the flow state is
     * `state`.
     */
    default predicate isBarrier(Node node, FlowState state) { none() }

    /** Holds if data flow into `node` is prohibited. */
    default predicate isBarrierIn(Node node) { none() }

    /** Holds if data flow into `node` is prohibited when the target flow state is `state`. */
    default predicate isBarrierIn(Node node, FlowState state) { none() }

    /** Holds if data flow out of `node` is prohibited. */
    default predicate isBarrierOut(Node node) { none() }

    /** Holds if data flow out of `node` is prohibited when the originating flow state is `state`. */
    default predicate isBarrierOut(Node node, FlowState state) { none() }

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
     */
    default predicate isAdditionalFlowStep(Node node1, Node node2) { none() }

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
     * This step is only applicable in `state1` and updates the flow state to `state2`.
     */
    default predicate isAdditionalFlowStep(
      Node node1, FlowState state1, Node node2, FlowState state2
    ) {
      none()
    }

    /**
     * Holds if an arbitrary number of implicit read steps of content `c` may be
     * taken at `node`.
     */
    default predicate allowImplicitRead(Node node, ContentSet c) { none() }

    /**
     * Holds if `node` should never be skipped over in the `PathGraph` and in path
     * explanations.
     */
    default predicate neverSkip(Node node) {
      isAdditionalFlowStep(node, _) or
      isAdditionalFlowStep(_, node) or
      isAdditionalFlowStep(node, _, _, _) or
      isAdditionalFlowStep(_, _, node, _)
    }

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
}

module DataFlowMake<InputSig Lang> {
  private import Lang
  private import internal.DataFlowImpl::MakeImpl<Lang>
  import Configs<Lang>

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
   * Constructs a global data flow computation.
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
   * Constructs a global data flow computation using flow state.
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
    predicate edges(PathNode a, PathNode b, string key, string val);

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
      query predicate edges(PathNode a, PathNode b, string key, string val) {
        Graph1::edges(a.asPathNode1(), b.asPathNode1(), key, val) or
        Graph2::edges(a.asPathNode2(), b.asPathNode2(), key, val)
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

  /**
   * Constructs a `PathGraph` from three `PathGraph`s by disjoint union.
   */
  module MergePathGraph3<
    PathNodeSig PathNode1, PathNodeSig PathNode2, PathNodeSig PathNode3,
    PathGraphSig<PathNode1> Graph1, PathGraphSig<PathNode2> Graph2, PathGraphSig<PathNode3> Graph3>
  {
    private module MergedInner = MergePathGraph<PathNode1, PathNode2, Graph1, Graph2>;

    private module Merged =
      MergePathGraph<MergedInner::PathNode, PathNode3, MergedInner::PathGraph, Graph3>;

    /** A node in a graph of path explanations that is formed by disjoint union of the three given graphs. */
    class PathNode instanceof Merged::PathNode {
      /** Gets this as a projection on the first given `PathGraph`. */
      PathNode1 asPathNode1() { result = super.asPathNode1().asPathNode1() }

      /** Gets this as a projection on the second given `PathGraph`. */
      PathNode2 asPathNode2() { result = super.asPathNode1().asPathNode2() }

      /** Gets this as a projection on the third given `PathGraph`. */
      PathNode3 asPathNode3() { result = super.asPathNode2() }

      /** Gets a textual representation of this element. */
      string toString() { result = super.toString() }

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
        super.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      }

      /** Gets the underlying `Node`. */
      Node getNode() { result = super.getNode() }
    }

    /**
     * Provides the query predicates needed to include a graph in a path-problem query.
     */
    module PathGraph implements PathGraphSig<PathNode> {
      /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
      query predicate edges(PathNode a, PathNode b, string key, string val) {
        Merged::PathGraph::edges(a, b, key, val)
      }

      /** Holds if `n` is a node in the graph of data flow path explanations. */
      query predicate nodes(PathNode n, string key, string val) {
        Merged::PathGraph::nodes(n, key, val)
      }

      /**
       * Holds if `(arg, par, ret, out)` forms a subpath-tuple, that is, flow through
       * a subpath between `par` and `ret` with the connecting edges `arg -> par` and
       * `ret -> out` is summarized as the edge `arg -> out`.
       */
      query predicate subpaths(PathNode arg, PathNode par, PathNode ret, PathNode out) {
        Merged::PathGraph::subpaths(arg, par, ret, out)
      }
    }
  }
}
