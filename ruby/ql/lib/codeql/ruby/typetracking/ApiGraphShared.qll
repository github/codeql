/**
 * Parts of API graphs that can be shared with other dynamic languages.
 *
 * Depends on TypeTrackerSpecific for the corresponding language.
 */

private import codeql.Locations
private import codeql.ruby.typetracking.TypeTracker
private import TypeTrackerSpecific

/**
 * The signature to use when instantiating `ApiGraphShared`.
 *
 * The implementor should define a newtype with at least three branches as follows:
 * ```ql
 * newtype TApiNode =
 *   MkForwardNode(LocalSourceNode node, TypeTracker t) { isReachable(node, t) } or
 *   MkBackwardNode(LocalSourceNode node, TypeTracker t) { isReachable(node, t) } or
 *   MkSinkNode(Node node) { ... } or
 *   ...
 * ```
 *
 * The three branches should be exposed through `getForwardNode`, `getBackwardNode`, and `getSinkNode`, respectively.
 */
signature module ApiGraphSharedSig {
  /** A node in the API graph. */
  class ApiNode {
    /** Gets a string representation of this API node. */
    string toString();

    /** Gets the location associated with this API node, if any. */
    Location getLocation();
  }

  /**
   * Gets the forward node with the given type-tracking state.
   *
   * This node will have outgoing epsilon edges to its type-tracking successors.
   */
  ApiNode getForwardNode(TypeTrackingNode node, TypeTracker t);

  /**
   * Gets the backward node with the given type-tracking state.
   *
   * This node will have outgoing epsilon edges to its type-tracking predecessors.
   */
  ApiNode getBackwardNode(TypeTrackingNode node, TypeTracker t);

  /**
   * Gets the sink node corresponding to `node`.
   *
   * Since sinks are not generally `LocalSourceNode`s, such nodes are materialised separately in order for
   * the API graph to include representatives for sinks. Note that there is no corresponding case for "source"
   * nodes as these are represented as forward nodes with initial-state type-trackers.
   *
   * Sink nodes have outgoing epsilon edges to the backward nodes corresponding to their local sources.
   */
  ApiNode getSinkNode(Node node);

  /**
   * Holds if a language-specific epsilon edge `pred -> succ` should be generated.
   */
  predicate specificEpsilonEdge(ApiNode pred, ApiNode succ);
}

/**
 * Parts of API graphs that can be shared between language implementations.
 */
module ApiGraphShared<ApiGraphSharedSig S> {
  private import S

  /** Gets a local source of `node`. */
  bindingset[node]
  pragma[inline_late]
  TypeTrackingNode getALocalSourceStrict(Node node) { result = node.getALocalSource() }

  cached
  private module Cached {
    /**
     * Holds if there is an epsilon edge `pred -> succ`.
     *
     * That relation is reflexive, so `fastTC` produces the equivalent of a reflexive, transitive closure.
     */
    pragma[noopt]
    cached
    predicate epsilonEdge(ApiNode pred, ApiNode succ) {
      exists(
        StepSummary summary, TypeTrackingNode predNode, TypeTracker predState,
        TypeTrackingNode succNode, TypeTracker succState
      |
        StepSummary::stepCall(predNode, succNode, summary)
        or
        StepSummary::stepNoCall(predNode, succNode, summary)
      |
        pred = getForwardNode(predNode, predState) and
        succState = StepSummary::append(predState, summary) and
        succ = getForwardNode(succNode, succState)
        or
        succ = getBackwardNode(predNode, predState) and // swap order for backward flow
        succState = StepSummary::append(predState, summary) and
        pred = getBackwardNode(succNode, succState) // swap order for backward flow
      )
      or
      exists(Node sink, TypeTrackingNode localSource |
        pred = getSinkNode(sink) and
        localSource = getALocalSourceStrict(sink) and
        succ = getBackwardStartNode(localSource)
      )
      or
      specificEpsilonEdge(pred, succ)
      or
      succ instanceof ApiNode and
      succ = pred
    }

    /**
     * Holds if `pred` can reach `succ` by zero or more epsilon edges.
     */
    cached
    predicate epsilonStar(ApiNode pred, ApiNode succ) = fastTC(epsilonEdge/2)(pred, succ)

    /** Gets the API node to use when starting forward flow from `source` */
    cached
    ApiNode forwardStartNode(TypeTrackingNode source) {
      result = getForwardNode(source, TypeTracker::end(false))
    }

    /** Gets the API node to use when starting backward flow from `sink` */
    cached
    ApiNode backwardStartNode(TypeTrackingNode sink) {
      // There is backward flow A->B iff there is forward flow B->A.
      // The starting point of backward flow corresponds to the end of a forward flow, and vice versa.
      result = getBackwardNode(sink, TypeTracker::end(_))
    }

    /** Gets `node` as a data flow source. */
    cached
    TypeTrackingNode asSourceCached(ApiNode node) { node = forwardEndNode(result) }

    /** Gets `node` as a data flow sink. */
    cached
    Node asSinkCached(ApiNode node) { node = getSinkNode(result) }
  }

  private import Cached

  /** Gets an API node corresponding to the end of forward-tracking to `localSource`. */
  pragma[nomagic]
  private ApiNode forwardEndNode(TypeTrackingNode localSource) {
    result = getForwardNode(localSource, TypeTracker::end(_))
  }

  /** Gets an API node corresponding to the end of backtracking to `localSource`. */
  pragma[nomagic]
  private ApiNode backwardEndNode(TypeTrackingNode localSource) {
    result = getBackwardNode(localSource, TypeTracker::end(false))
  }

  /** Gets a node reachable from `node` by zero or more epsilon edges, including `node` itself. */
  bindingset[node]
  pragma[inline_late]
  ApiNode getAnEpsilonSuccessorInline(ApiNode node) { epsilonStar(node, result) }

  /** Gets `node` as a data flow sink. */
  bindingset[node]
  pragma[inline_late]
  Node asSinkInline(ApiNode node) { result = asSinkCached(node) }

  /** Gets `node` as a data flow source. */
  bindingset[node]
  pragma[inline_late]
  TypeTrackingNode asSourceInline(ApiNode node) { result = asSourceCached(node) }

  /** Gets a value reachable from `source`. */
  bindingset[source]
  pragma[inline_late]
  Node getAValueReachableFromSourceInline(ApiNode source) {
    exists(TypeTrackingNode src |
      src = asSourceInline(getAnEpsilonSuccessorInline(source)) and
      src.flowsTo(pragma[only_bind_into](result))
    )
  }

  /** Gets a value that can reach `sink`. */
  bindingset[sink]
  pragma[inline_late]
  Node getAValueReachingSinkInline(ApiNode sink) {
    result = asSinkInline(getAnEpsilonSuccessorInline(sink))
  }

  /**
   * Gets the starting point for forward-tracking at `node`.
   *
   * Should be used to obtain the successor of an edge when constructing labelled edges.
   */
  bindingset[node]
  pragma[inline_late]
  ApiNode getForwardStartNode(Node node) { result = forwardStartNode(node) }

  /**
   * Gets the starting point of backtracking from `node`.
   *
   * Should be used to obtain the successor of an edge when constructing labelled edges.
   */
  bindingset[node]
  pragma[inline_late]
  ApiNode getBackwardStartNode(Node node) { result = backwardStartNode(node) }

  /**
   * Gets a possible ending point of forward-tracking at `node`.
   *
   * Should be used to obtain the predecessor of an edge when constructing labelled edges.
   *
   * This is not backed by a `cached` predicate, and should only be used for materialising `cached`
   * predicates in the API graph implementation - it should not be called in later stages.
   */
  bindingset[node]
  pragma[inline_late]
  ApiNode getForwardEndNode(Node node) { result = forwardEndNode(node) }

  /**
   * Gets a possible ending point backtracking to `node`.
   *
   * Should be used to obtain the predecessor of an edge when constructing labelled edges.
   *
   * This is not backed by a `cached` predicate, and should only be used for materialising `cached`
   * predicates in the API graph implementation - it should not be called in later stages.
   */
  bindingset[node]
  pragma[inline_late]
  ApiNode getBackwardEndNode(Node node) { result = backwardEndNode(node) }

  /**
   * Gets a possible eding point of forward or backward tracking at `node`.
   *
   * Should be used to obtain the predecessor of an edge generated from store or load edges.
   */
  bindingset[node]
  pragma[inline_late]
  ApiNode getForwardOrBackwardEndNode(Node node) {
    result = getForwardEndNode(node) or result = getBackwardEndNode(node)
  }

  /** Gets an API node for tracking forward starting at `node`. This is the implementation of `DataFlow::LocalSourceNode.track()` */
  bindingset[node]
  pragma[inline_late]
  ApiNode getNodeForForwardTracking(Node node) { result = forwardStartNode(node) }

  /** Gets an API node for backtracking starting at `node`. The implementation of `DataFlow::Node.backtrack()`. */
  bindingset[node]
  pragma[inline_late]
  ApiNode getNodeForBacktracking(Node node) {
    result = getBackwardStartNode(getALocalSourceStrict(node))
  }

  /** Parts of the shared module to be re-exported by the user-facing `API` module. */
  module Public {
    /**
     * The signature to use when instantiating the `ExplainFlow` module.
     */
    signature module ExplainFlowSig {
      /** Holds if `node` should be a source. */
      predicate isSource(ApiNode node);

      /** Holds if `node` should be a sink. */
      default predicate isSink(ApiNode node) { any() }

      /** Holds if `node` should be skipped in the generated paths. */
      default predicate isHidden(ApiNode node) { none() }
    }

    /**
     * Module to help debug and visualize the data flows underlying API graphs.
     *
     * This module exports the query predicates for a path-problem query, and should be imported
     * into the top-level of such a query.
     *
     * The module argument should specify source and sink API nodes, and the resulting query
     * will show paths of epsilon edges that go from a source to a sink. Only epsilon edges are visualized.
     *
     * To condense the output a bit, paths in which the source and sink are the same node are omitted.
     */
    module ExplainFlow<ExplainFlowSig T> {
      private import T

      private ApiNode relevantNode() {
        isSink(result) and
        result = getAnEpsilonSuccessorInline(any(ApiNode node | isSource(node)))
        or
        epsilonEdge(result, relevantNode())
      }

      /** Holds if `node` is part of the graph to visualize. */
      query predicate nodes(ApiNode node) { node = relevantNode() and not isHidden(node) }

      private predicate edgeToHiddenNode(ApiNode pred, ApiNode succ) {
        epsilonEdge(pred, succ) and
        isHidden(succ) and
        pred = relevantNode() and
        succ = relevantNode()
      }

      /** Holds if `pred -> succ` is an edge in the graph to visualize. */
      query predicate edges(ApiNode pred, ApiNode succ) {
        nodes(pred) and
        nodes(succ) and
        exists(ApiNode mid |
          edgeToHiddenNode*(pred, mid) and
          epsilonEdge(mid, succ)
        )
      }

      /** Holds for each source/sink pair to visualize in the graph. */
      query predicate problems(
        ApiNode location, ApiNode sourceNode, ApiNode sinkNode, string message
      ) {
        nodes(sourceNode) and
        nodes(sinkNode) and
        isSource(sourceNode) and
        isSink(sinkNode) and
        sinkNode = getAnEpsilonSuccessorInline(sourceNode) and
        sourceNode != sinkNode and
        location = sinkNode and
        message = "Node flows here"
      }
    }
  }
}
