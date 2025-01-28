/**
 * Provides an implementation of global (interprocedural) data flow. This file
 * adds a global analysis, mainly exposed through the `Global` and `GlobalWithState`
 * modules.
 */

private import codeql.util.Location

/** Provides language-specific data flow parameters. */
signature module InputSig<LocationSig Location> {
  /**
   * A node in the data flow graph.
   */
  class Node {
    /** Gets a textual representation of this element. */
    string toString();

    /** Gets the location of this node. */
    Location getLocation();
  }

  class ParameterNode extends Node;

  class ArgumentNode extends Node;

  class ReturnNode extends Node {
    ReturnKind getKind();
  }

  /**
   * A node in the data flow graph that represents an output of a call.
   */
  class OutNode extends Node;

  /**
   * A node in the data flow graph representing the value of some other node
   * after an operation that might have changed its state. A typical example is
   * an argument, which may have been modified by the callee. For example,
   * consider the following code calling a setter method:
   * ```
   * x.setFoo(y);
   * ```
   * The post-update node for the argument node `x` is the node representing the
   * value of `x` after the field `foo` has been updated.
   */
  class PostUpdateNode extends Node {
    /**
     * Gets the pre-update node, that is, the node that represents the same
     * value prior to the operation.
     */
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

    /** Gets the location of this call. */
    Location getLocation();

    DataFlowCallable getEnclosingCallable();
  }

  class DataFlowCallable {
    /** Gets a textual representation of this element. */
    string toString();

    /** Gets the location of this callable. */
    Location getLocation();
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

  /**
   * Holds if access paths with `c` at their head always should be tracked at
   * high precision. This disables adaptive access path precision for such
   * access paths. This may be beneficial for content that indicates an
   * element of an array or container.
   */
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

  /**
   * A content approximation. A content approximation corresponds to one or
   * more `Content`s, and is used to provide an in-between level of precision
   * for pruning.
   */
  class ContentApprox {
    /** Gets a textual representation of this element. */
    string toString();
  }

  /**
   * Gets the content approximation for content `c`.
   */
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

  /**
   * Holds if the parameter position `ppos` matches the argument position
   * `apos`.
   */
  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos);

  /**
   * Holds if there is a simple local flow step from `node1` to `node2`. These
   * are the value-preserving intra-callable flow steps.
   */
  predicate simpleLocalFlowStep(Node node1, Node node2, string model);

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

  /** A set of `Node`s in a `DataFlowCallable`. */
  class NodeRegion {
    /** Holds if this region contains `n`. */
    predicate contains(Node n);
  }

  /**
   * Holds if the nodes in `nr` are unreachable when the call context is `call`.
   */
  predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call);

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

  predicate knownSourceModel(Node source, string model);

  predicate knownSinkModel(Node sink, string model);

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

  /**
   * A second-level control-flow scope in a callable.
   *
   * This is used to provide a more fine-grained separation of a callable
   * context for the purpose of identifying uncertain control flow. For most
   * languages, this is not needed, as this separation is handled through
   * virtual dispatch, but for some cases (for example, C++) this can be used to
   * identify, for example, large top-level switch statements acting like
   * virtual dispatch.
   */
  class DataFlowSecondLevelScope {
    /** Gets a textual representation of this element. */
    string toString();
  }

  /** Gets the second-level scope containing the node `n`, if any. */
  default DataFlowSecondLevelScope getSecondLevelScope(Node n) { none() }

  bindingset[call, p, arg]
  default predicate golangSpecificParamArgFilter(
    DataFlowCall call, ParameterNode p, ArgumentNode arg
  ) {
    any()
  }

  /** Holds if `fieldFlowBranchLimit` should be ignored for flow going into/out of `c`. */
  default predicate ignoreFieldFlowBranchLimit(DataFlowCallable c) { none() }
}

module Configs<LocationSig Location, InputSig<Location> Lang> {
  private import Lang
  private import internal.DataFlowImplCommon::MakeImplCommon<Location, Lang>
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

    /** Gets the access path limit. */
    default int accessPathLimit() { result = Lang::accessPathLimit() }

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

    /**
     * Holds if hidden nodes should be included in the data flow graph.
     *
     * This feature should only be used for debugging or when the data flow graph
     * is not visualized (as it is in a `path-problem` query).
     */
    default predicate includeHiddenNodes() { none() }

    /**
     * Holds if sources and sinks should be filtered to only include those that
     * may lead to a flow path with either a source or a sink in the location
     * range given by `AlertFiltering`. This only has an effect when running
     * in diff-informed incremental mode.
     *
     * This flag should only be applied to flow configurations whose results
     * are used directly in a query result.
     */
    default predicate observeDiffInformedIncrementalMode() { none() }

    /**
     * Gets a location that will be associated with the given `source` in a
     * diff-informed query that uses this configuration (see
     * `observeDiffInformedIncrementalMode`). By default, this is the location
     * of the source itself, but this predicate should include any locations
     * that are reported as the primary-location of the query or as an
     * additional location ("$@" interpolation). For a query that doesn't
     * report the source at all, this predicate can be `none()`.
     */
    default Location getASelectedSourceLocation(Node source) { result = source.getLocation() }

    /**
     * Gets a location that will be associated with the given `sink` in a
     * diff-informed query that uses this configuration (see
     * `observeDiffInformedIncrementalMode`). By default, this is the location
     * of the sink itself, but this predicate should include any locations
     * that are reported as the primary-location of the query or as an
     * additional location ("$@" interpolation). For a query that doesn't
     * report the sink at all, this predicate can be `none()`.
     */
    default Location getASelectedSinkLocation(Node sink) { result = sink.getLocation() }
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

    /** Gets the access path limit. */
    default int accessPathLimit() { result = Lang::accessPathLimit() }

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

    /**
     * Holds if hidden nodes should be included in the data flow graph.
     *
     * This feature should only be used for debugging or when the data flow graph
     * is not visualized (as it is in a `path-problem` query).
     */
    default predicate includeHiddenNodes() { none() }

    /**
     * Holds if sources and sinks should be filtered to only include those that
     * may lead to a flow path with either a source or a sink in the location
     * range given by `AlertFiltering`. This only has an effect when running
     * in diff-informed incremental mode.
     *
     * This flag should only be applied to flow configurations whose results
     * are used directly in a query result.
     */
    default predicate observeDiffInformedIncrementalMode() { none() }

    /**
     * Gets a location that will be associated with the given `source` in a
     * diff-informed query that uses this configuration (see
     * `observeDiffInformedIncrementalMode`). By default, this is the location
     * of the source itself, but this predicate should include any locations
     * that are reported as the primary-location of the query or as an
     * additional location ("$@" interpolation). For a query that doesn't
     * report the source at all, this predicate can be `none()`.
     */
    default Location getASelectedSourceLocation(Node source) { result = source.getLocation() }

    /**
     * Gets a location that will be associated with the given `sink` in a
     * diff-informed query that uses this configuration (see
     * `observeDiffInformedIncrementalMode`). By default, this is the location
     * of the sink itself, but this predicate should include any locations
     * that are reported as the primary-location of the query or as an
     * additional location ("$@" interpolation). For a query that doesn't
     * report the sink at all, this predicate can be `none()`.
     */
    default Location getASelectedSinkLocation(Node sink) { result = sink.getLocation() }
  }
}

/** A type with `toString`. */
private signature class TypeWithToString {
  string toString();
}

import PathGraphSigMod

private module PathGraphSigMod {
  signature module PathGraphSig<TypeWithToString PathNode> {
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
}

module DataFlowMake<LocationSig Location, InputSig<Location> Lang> {
  private import Lang
  private import internal.DataFlowImpl::MakeImpl<Location, Lang>
  import Configs<Location, Lang>

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

      predicate accessPathLimit = Config::accessPathLimit/0;

      predicate isAdditionalFlowStep(Node node1, Node node2, string model) {
        Config::isAdditionalFlowStep(node1, node2) and model = "Config"
      }
    }

    import Impl<C>
  }

  /**
   * Constructs a global data flow computation using flow state.
   */
  module GlobalWithState<StateConfigSig Config> implements GlobalFlowSig {
    private module C implements FullStateConfigSig {
      import Config

      predicate accessPathLimit = Config::accessPathLimit/0;

      predicate isAdditionalFlowStep(Node node1, Node node2, string model) {
        Config::isAdditionalFlowStep(node1, node2) and model = "Config"
      }

      predicate isAdditionalFlowStep(
        Node node1, FlowState state1, Node node2, FlowState state2, string model
      ) {
        Config::isAdditionalFlowStep(node1, state1, node2, state2) and model = "Config"
      }
    }

    import Impl<C>
  }

  signature class PathNodeSig {
    /** Gets a textual representation of this element. */
    string toString();

    /** Gets the underlying `Node`. */
    Node getNode();

    /** Gets the location of this node. */
    Location getLocation();
  }

  import PathGraphSigMod

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

      /** Gets the underlying `Node`. */
      Node getNode() {
        result = this.asPathNode1().getNode() or
        result = this.asPathNode2().getNode()
      }

      /** Gets the location of this node. */
      Location getLocation() { result = this.getNode().getLocation() }

      /**
       * Holds if this element is at the specified location.
       * The location spans column `startcolumn` of line `startline` to
       * column `endcolumn` of line `endline` in file `filepath`.
       * For more information, see
       * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
       */
      deprecated predicate hasLocationInfo(
        string filepath, int startline, int startcolumn, int endline, int endcolumn
      ) {
        this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
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
      deprecated predicate hasLocationInfo(
        string filepath, int startline, int startcolumn, int endline, int endcolumn
      ) {
        super.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      }

      /** Gets the underlying `Node`. */
      Node getNode() { result = super.getNode() }

      /** Gets the location of this node. */
      Location getLocation() { result = super.getLocation() }
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

  /**
   * Generates a `PathGraph` in which equivalent path nodes are merged, in order to avoid duplicate paths.
   */
  module DeduplicatePathGraph<PathNodeSig InputPathNode, PathGraphSig<InputPathNode> Graph> {
    // NOTE: there is a known limitation in that this module cannot see which nodes are sources or sinks.
    // This only matters in the rare case where a sink PathNode has a non-empty set of succesors, and there is a
    // non-sink PathNode with the same `(node, toString)` value and the same successors, but is transitively
    // reachable from a different set of PathNodes. (And conversely for sources).
    //
    pragma[nomagic]
    private InputPathNode getAPathNode(Node node, string toString) {
      result.getNode() = node and
      Graph::nodes(result, _, toString)
    }

    private signature predicate collapseCandidateSig(Node node, string toString);

    private signature predicate stepSig(
      InputPathNode node1, InputPathNode node2, string key, string val
    );

    private signature predicate subpathStepSig(
      InputPathNode arg, InputPathNode param, InputPathNode ret, InputPathNode out
    );

    /**
     * Performs a forward or backward pass computing which `(node, toString)` pairs can subsume their corresponding
     * path nodes.
     *
     * This is similar to automaton minimization, but for an NFA. Since minimizing an NFA is NP-hard (and does not have
     * a unique minimal NFA), we operate with the simpler model: for a given `(node, toString)` pair, either all
     * corresponding path nodes are merged, or none are merged.
     *
     * Comments are written as if this checks for outgoing edges and propagates backward, though the module is also
     * used to perform the opposite direction.
     */
    private module MakeDiscriminatorPass<
      collapseCandidateSig/2 collapseCandidate, stepSig/4 step, subpathStepSig/4 subpathStep>
    {
      /**
       * Gets the number of `(key, val, node, toString)` tuples reachable in one step from `pathNode`.
       *
       * That is, two edges are counted as one if their target nodes are the same after projection, and the edges have the
       * same `(key, val)`.
       */
      private int getOutDegreeFromPathNode(InputPathNode pathNode) {
        result =
          count(Node node, string toString, string key, string val |
            step(pathNode, getAPathNode(node, toString), key, val)
          )
      }

      /**
       * Gets the number of `(key, val, node2, toString2)` pairs reachable in one step from path nodes corresponding to `(node, toString)`.
       */
      private int getOutDegreeFromNode(Node node, string toString) {
        result =
          strictcount(Node node2, string toString2, string key, string val |
            step(getAPathNode(node, toString), getAPathNode(node2, toString2), key, val)
          )
      }

      /**
       * Like `getOutDegreeFromPathNode` except counts `subpath` tuples.
       */
      private int getSubpathOutDegreeFromPathNode(InputPathNode pathNode) {
        result =
          count(Node n1, string s1, Node n2, string s2, Node n3, string s3 |
            subpathStep(pathNode, getAPathNode(n1, s1), getAPathNode(n2, s2), getAPathNode(n3, s3))
          )
      }

      /**
       * Like `getOutDegreeFromNode` except counts `subpath` tuples.
       */
      private int getSubpathOutDegreeFromNode(Node node, string toString) {
        result =
          strictcount(Node n1, string s1, Node n2, string s2, Node n3, string s3 |
            subpathStep(getAPathNode(node, toString), getAPathNode(n1, s1), getAPathNode(n2, s2),
              getAPathNode(n3, s3))
          )
      }

      /** Gets a successor of `node`, including subpath flow-through, but not enter or exit subpath steps. */
      InputPathNode stepEx(InputPathNode node) {
        step(node, result, _, _) and
        not result = enterSubpathStep(node) and
        not result = exitSubpathStep(node)
        or
        // Assuming the input is pruned properly, all subpaths have flow-through.
        // This step should be in 'step' as well, but include it here for clarity as we rely on it.
        subpathStep(node, _, _, result)
      }

      InputPathNode enterSubpathStep(InputPathNode node) { subpathStep(node, result, _, _) }

      InputPathNode exitSubpathStep(InputPathNode node) { subpathStep(_, _, node, result) }

      /** Holds if `(node, toString)` cannot be collapsed (but was a candidate for being collapsed). */
      predicate discriminatedPair(Node node, string toString, boolean hasEnter) {
        collapseCandidate(node, toString) and
        hasEnter = false and
        (
          // Check if all corresponding PathNodes have the same successor sets when projected to `(node, toString)`.
          // To do this, we check that each successor set has the same size as the union of the succesor sets.
          // - If the successor sets are equal, then they are also equal to their union, and so have the correct size.
          // - Conversely, if two successor sets are not equal, one of them must be missing an element that is present
          //   in the union, but must still be a subset of the union, and thus be strictly smaller than the union.
          getOutDegreeFromPathNode(getAPathNode(node, toString)) <
            getOutDegreeFromNode(node, toString)
          or
          // Same as above but counting associated subpath triples instead
          getSubpathOutDegreeFromPathNode(getAPathNode(node, toString)) <
            getSubpathOutDegreeFromNode(node, toString)
        )
        or
        collapseCandidate(node, toString) and
        (
          // Retain flow state if one of the successors requires it to be retained
          discriminatedPathNode(stepEx(getAPathNode(node, toString)), hasEnter)
          or
          // Propagate backwards from parameter to argument
          discriminatedPathNode(enterSubpathStep(getAPathNode(node, toString)), false) and
          hasEnter = false
          or
          // Propagate backwards from out to return
          discriminatedPathNode(exitSubpathStep(getAPathNode(node, toString)), _) and
          hasEnter = true
        )
      }

      /** Holds if `pathNode` cannot be collapsed. */
      private predicate discriminatedPathNode(InputPathNode pathNode, boolean hasEnter) {
        exists(Node node, string toString |
          discriminatedPair(node, toString, hasEnter) and
          getAPathNode(node, toString) = pathNode
        )
      }

      /** Holds if `(node, toString)` cannot be collapsed (but was a candidate for being collapsed). */
      predicate discriminatedPair(Node node, string toString) {
        discriminatedPair(node, toString, _)
      }

      /** Holds if `pathNode` cannot be collapsed. */
      predicate discriminatedPathNode(InputPathNode pathNode) { discriminatedPathNode(pathNode, _) }
    }

    private InputPathNode getUniqPathNode(Node node, string toString) {
      result = unique(InputPathNode pathNode | pathNode = getAPathNode(node, toString))
    }

    private predicate initialCandidate(Node node, string toString) {
      exists(getAPathNode(node, toString)) and not exists(getUniqPathNode(node, toString))
    }

    private module Pass1 =
      MakeDiscriminatorPass<initialCandidate/2, Graph::edges/4, Graph::subpaths/4>;

    private predicate edgesRev(InputPathNode node1, InputPathNode node2, string key, string val) {
      Graph::edges(node2, node1, key, val)
    }

    private predicate subpathsRev(
      InputPathNode n1, InputPathNode n2, InputPathNode n3, InputPathNode n4
    ) {
      Graph::subpaths(n4, n3, n2, n1)
    }

    private module Pass2 =
      MakeDiscriminatorPass<Pass1::discriminatedPair/2, edgesRev/4, subpathsRev/4>;

    private newtype TPathNode =
      TPreservedPathNode(InputPathNode node) {
        Pass2::discriminatedPathNode(node) or node = getUniqPathNode(_, _)
      } or
      TCollapsedPathNode(Node node, string toString) {
        initialCandidate(node, toString) and
        not Pass2::discriminatedPair(node, toString)
      }

    /** A node in the path graph after equivalent nodes have been collapsed. */
    class PathNode extends TPathNode {
      private Node asCollapsedNode() { this = TCollapsedPathNode(result, _) }

      private InputPathNode asPreservedNode() { this = TPreservedPathNode(result) }

      /** Gets a correspondng node in the original graph. */
      InputPathNode getAnOriginalPathNode() {
        exists(Node node, string toString |
          this = TCollapsedPathNode(node, toString) and
          result = getAPathNode(node, toString)
        )
        or
        result = this.asPreservedNode()
      }

      /** Gets a string representation of this node. */
      string toString() {
        result = this.asPreservedNode().toString() or this = TCollapsedPathNode(_, result)
      }

      /** Gets the location of this node. */
      Location getLocation() { result = this.getAnOriginalPathNode().getLocation() }

      /** Gets the corresponding data-flow node. */
      Node getNode() {
        result = this.asCollapsedNode()
        or
        result = this.asPreservedNode().getNode()
      }
    }

    /**
     * Provides the query predicates needed to include a graph in a path-problem query.
     */
    module PathGraph implements PathGraphSig<PathNode> {
      query predicate nodes(PathNode node, string key, string val) {
        Graph::nodes(node.getAnOriginalPathNode(), key, val)
      }

      query predicate edges(PathNode node1, PathNode node2, string key, string val) {
        Graph::edges(node1.getAnOriginalPathNode(), node2.getAnOriginalPathNode(), key, val)
      }

      query predicate subpaths(PathNode arg, PathNode par, PathNode ret, PathNode out) {
        // Note: this may look suspiciously simple, but it's not an oversight. Even if the caller needs to retain state,
        // it is entirely possible to step through a subpath in which state has been projected away.
        Graph::subpaths(arg.getAnOriginalPathNode(), par.getAnOriginalPathNode(),
          ret.getAnOriginalPathNode(), out.getAnOriginalPathNode())
      }
    }

    // Re-export the PathGraph so the user can import a single module and get both PathNode and the query predicates
    import PathGraph
  }
}
