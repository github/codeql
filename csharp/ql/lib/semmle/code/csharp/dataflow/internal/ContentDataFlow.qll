/**
 * Provides classes for performing global (inter-procedural)
 * content-sensitive data flow analyses.
 */

private import DataFlowImplCommon

module ContentDataFlow {
  private import DataFlowImplSpecific::Private
  private import DataFlowImplSpecific::Private as DataFlowPrivate
  private import DataFlowImplForContentDataFlow as DF

  class Node = DF::Node;

  class FlowFeature = DF::FlowFeature;

  class ContentSet = DF::ContentSet;

  predicate stageStats = DF::stageStats/8;

  /**
   * A configuration of interprocedural data flow analysis. This defines
   * sources, sinks, and any other configurable aspect of the analysis. Each
   * use of the global data flow library must define its own unique extension
   * of this abstract class. To create a configuration, extend this class with
   * a subclass whose characteristic predicate is a unique singleton string.
   * For example, write
   *
   * ```ql
   * class MyAnalysisConfiguration extends ContentDataFlowConfiguration {
   *   MyAnalysisConfiguration() { this = "MyAnalysisConfiguration" }
   *   // Override `isSource` and `isSink`.
   *   // Optionally override `isBarrier`.
   *   // Optionally override `isAdditionalFlowStep`.
   *   // Optionally override `getAFeature`.
   *   // Optionally override `accessPathLimit`.
   *   // Optionally override `isRelevantContent`.
   * }
   * ```
   *
   * Unlike `DataFlow::Configuration` (on which this class is based), we allow
   * for data to be stored (possibly nested) inside contents of sources and sinks.
   * We track flow paths of the form
   *
   * ```
   * source --value-->* node
   *        (--read--> node --value-->* node)*
   *        --(non-value|value)-->* node
   *        (--store--> node --value-->* node)*
   *        --value-->* sink
   * ```
   *
   * where `--value-->` is a value-preserving flow step, `--read-->` is a read
   * step, `--store-->` is a store step, and `--(non-value)-->` is a
   * non-value-preserving flow step.
   *
   * That is, first a sequence of 0 or more reads, followed by 0 or more additional
   * steps, followed by 0 or more stores, with value-preserving steps allowed in
   * between all other steps.
   */
  abstract class Configuration extends string {
    bindingset[this]
    Configuration() { any() }

    /**
     * Holds if `source` is a relevant data flow source.
     */
    abstract predicate isSource(Node source);

    /**
     * Holds if `sink` is a relevant data flow sink.
     */
    abstract predicate isSink(Node sink);

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
     */
    predicate isAdditionalFlowStep(Node node1, Node node2) { none() }

    /** Holds if data flow into `node` is prohibited. */
    predicate isBarrier(Node node) { none() }

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
     */
    FlowFeature getAFeature() { none() }

    /** Gets a limit on the number of reads out of sources and number of stores into sinks. */
    int accessPathLimit() { result = DataFlowPrivate::accessPathLimit() }

    /** Holds if `c` is relevant for reads out of sources or stores into sinks. */
    predicate isRelevantContent(ContentSet c) { any() }

    /**
     * Holds if data stored inside `sourceAp` on `source` flows to `sinkAp` inside `sink`
     * for this configuration. `preservesValue` indicates whether any of the additional
     * flow steps defined by `isAdditionalFlowStep` are needed.
     *
     * For the source access path, `sourceAp`, the top of the stack represents the content
     * that was last read from. That is, if `sourceAp` is `Field1.Field2` (with `Field1`
     * being the top of the stack), then there is flow from `source.Field2.Field1`.
     *
     * For the sink access path, `sinkAp`, the top of the stack represents the content
     * that was last stored into. That is, if `sinkAp` is `Field1.Field2` (with `Field1`
     * being the top of the stack), then there is flow into `sink.Field1.Field2`.
     */
    final predicate hasFlow(
      Node source, AccessPath sourceAp, Node sink, AccessPath sinkAp, boolean preservesValue
    ) {
      exists(DF::PathNode pathSource, DF::PathNode pathSink |
        this.(ConfigurationAdapter).hasFlowPath(pathSource, pathSink) and
        nodeReaches(pathSource, TAccessPathNil(), TAccessPathNil(), pathSink, sourceAp, sinkAp) and
        source = pathSource.getNode() and
        sink = pathSink.getNode()
      |
        pathSink.getState().(InitState).decode(preservesValue)
        or
        pathSink.getState().(ReadState).decode(_, preservesValue)
        or
        pathSink.getState().(StoreState).decode(_, preservesValue)
      )
    }
  }

  /** A flow state representing no reads or stores. */
  private class InitState extends DF::FlowState {
    private boolean preservesValue_;

    InitState() { this = "Init(" + preservesValue_ + ")" and preservesValue_ in [false, true] }

    predicate decode(boolean preservesValue) { preservesValue = preservesValue_ }
  }

  /** A flow state representing that content has been stored into. */
  private class StoreState extends DF::FlowState {
    private boolean preservesValue_;
    private int size_;

    StoreState() {
      preservesValue_ in [false, true] and
      size_ in [1 .. any(Configuration c).accessPathLimit()] and
      this = "StoreState(" + size_ + "," + preservesValue_ + ")"
    }

    predicate decode(int size, boolean preservesValue) {
      size = size_ and preservesValue = preservesValue_
    }
  }

  /** A flow state representing that content has been read from. */
  private class ReadState extends DF::FlowState {
    private boolean preservesValue_;
    private int size_;

    ReadState() {
      preservesValue_ in [false, true] and
      size_ in [1 .. any(Configuration c).accessPathLimit()] and
      this = "ReadState(" + size_ + "," + preservesValue_ + ")"
    }

    predicate decode(int size, boolean preservesValue) {
      size = size_ and preservesValue = preservesValue_
    }
  }

  private predicate storeStep(
    Node node1, DF::FlowState state1, ContentSet c, Node node2, StoreState state2,
    Configuration config
  ) {
    exists(boolean preservesValue, int size |
      storeSet(node1, c, node2, _, _) and
      config.isRelevantContent(c) and
      state2.decode(size + 1, preservesValue)
    |
      state1.(InitState).decode(preservesValue) and size = 0
      or
      state1.(ReadState).decode(_, preservesValue) and size = 0
      or
      state1.(StoreState).decode(size, preservesValue)
    )
  }

  private predicate readStep(
    Node node1, DF::FlowState state1, ContentSet c, Node node2, ReadState state2,
    Configuration config
  ) {
    exists(int size |
      readSet(node1, c, node2) and
      config.isRelevantContent(c) and
      state2.decode(size + 1, true)
    |
      state1.(InitState).decode(true) and
      size = 0
      or
      state1.(ReadState).decode(size, true)
    )
  }

  private predicate additionalStep(
    Node node1, DF::FlowState state1, Node node2, DF::FlowState state2, Configuration config
  ) {
    config.isAdditionalFlowStep(node1, node2) and
    (
      state1 instanceof InitState and
      state2.(InitState).decode(false)
      or
      exists(int size |
        state1.(ReadState).decode(size, _) and
        state2.(ReadState).decode(size, false)
      )
    )
  }

  private class ConfigurationAdapter extends DF::Configuration instanceof Configuration {
    final override predicate isSource(Node source, DF::FlowState state) {
      Configuration.super.isSource(source) and
      state.(InitState).decode(true)
    }

    final override predicate isSink(Node sink, DF::FlowState state) {
      Configuration.super.isSink(sink) and
      (
        state instanceof InitState or
        state instanceof StoreState or
        state instanceof ReadState
      )
    }

    final override predicate isAdditionalFlowStep(
      Node node1, DF::FlowState state1, Node node2, DF::FlowState state2
    ) {
      storeStep(node1, state1, _, node2, state2, this) or
      readStep(node1, state1, _, node2, state2, this) or
      additionalStep(node1, state1, node2, state2, this)
    }

    final override predicate isBarrier(Node node) { Configuration.super.isBarrier(node) }

    final override FlowFeature getAFeature() { result = Configuration.super.getAFeature() }

    // needed to record reads/stores inside summarized callables
    final override predicate includeHiddenNodes() { any() }
  }

  private newtype TAccessPath =
    TAccessPathNil() or
    TAccessPathCons(ContentSet head, AccessPath tail) {
      nodeReachesStore(_, _, _, _, head, _, tail)
      or
      nodeReachesRead(_, _, _, _, head, tail, _)
    }

  /** An access path. */
  class AccessPath extends TAccessPath {
    /** Gets the head of this access path, if any. */
    ContentSet getHead() { this = TAccessPathCons(result, _) }

    /** Gets the tail of this access path, if any. */
    AccessPath getTail() { this = TAccessPathCons(_, result) }

    /**
     * Gets a textual representation of this access path.
     *
     * Elements are dot-separated, and the head of the stack is
     * rendered first.
     */
    string toString() {
      this = TAccessPathNil() and
      result = ""
      or
      exists(ContentSet head, AccessPath tail |
        this = TAccessPathCons(head, tail) and
        result = head + "." + tail
      )
    }
  }

  // important to use `edges` and not `PathNode::getASuccessor()`, as the latter
  // is not pruned for reachability
  private predicate pathSucc = DF::PathGraph::edges/2;

  /**
   * Provides a big-step flow relation, where flow stops at read/store steps that
   * must be recorded, and flow via `subpaths` such that reads/stores inside
   * summarized callables can be recorded as well.
   */
  private module BigStepFlow {
    private predicate reachesSink(DF::PathNode node) {
      any(ConfigurationAdapter config).isSink(node.getNode(), node.getState())
      or
      exists(DF::PathNode mid |
        pathSucc(node, mid) and
        reachesSink(mid)
      )
    }

    /**
     * Holds if the flow step `pred -> succ` should not be allowed to be included
     * in the big-step relation.
     */
    pragma[nomagic]
    private predicate excludeStep(DF::PathNode pred, DF::PathNode succ) {
      pathSucc(pred, succ) and
      (
        // we need to record reads/stores inside summarized callables
        DF::PathGraph::subpaths(pred, _, _, succ)
        or
        // only allow flow into a summarized callable, as part of the big-step
        // relation, when flow can reach a sink without going back out
        DF::PathGraph::subpaths(pred, succ, _, _) and
        not reachesSink(succ)
        or
        // needed to record store steps
        storeStep(pred.getNode(), pred.getState(), _, succ.getNode(), succ.getState(),
          pred.getConfiguration())
        or
        // needed to record read steps
        readStep(pred.getNode(), pred.getState(), _, succ.getNode(), succ.getState(),
          pred.getConfiguration())
      )
    }

    pragma[nomagic]
    private DataFlowCallable getEnclosingCallableImpl(DF::PathNode node) {
      result = getNodeEnclosingCallable(node.getNode())
    }

    pragma[inline]
    private DataFlowCallable getEnclosingCallable(DF::PathNode node) {
      pragma[only_bind_into](result) = getEnclosingCallableImpl(pragma[only_bind_out](node))
    }

    pragma[nomagic]
    private predicate bigStepEntry(DF::PathNode node) {
      node.getConfiguration() instanceof Configuration and
      (
        any(ConfigurationAdapter config).isSource(node.getNode(), node.getState())
        or
        excludeStep(_, node)
        or
        DF::PathGraph::subpaths(_, node, _, _)
      )
    }

    pragma[nomagic]
    private predicate bigStepExit(DF::PathNode node) {
      node.getConfiguration() instanceof Configuration and
      (
        bigStepEntry(node)
        or
        any(ConfigurationAdapter config).isSink(node.getNode(), node.getState())
        or
        excludeStep(node, _)
        or
        DF::PathGraph::subpaths(_, _, node, _)
      )
    }

    pragma[nomagic]
    private predicate step(DF::PathNode pred, DF::PathNode succ) {
      pathSucc(pred, succ) and
      not excludeStep(pred, succ)
    }

    pragma[nomagic]
    private predicate stepRec(DF::PathNode pred, DF::PathNode succ) {
      step(pred, succ) and
      not bigStepEntry(pred)
    }

    private predicate stepRecPlus(DF::PathNode n1, DF::PathNode n2) = fastTC(stepRec/2)(n1, n2)

    /**
     * Holds if there is flow `pathSucc+(pred) = succ`, and such a flow path does
     * not go through any reads/stores that need to be recorded, or summarized
     * steps.
     */
    pragma[nomagic]
    private predicate bigStep(DF::PathNode pred, DF::PathNode succ) {
      exists(DF::PathNode mid |
        bigStepEntry(pred) and
        step(pred, mid)
      |
        succ = mid
        or
        stepRecPlus(mid, succ)
      ) and
      bigStepExit(succ)
    }

    pragma[nomagic]
    predicate bigStepNotLocal(DF::PathNode pred, DF::PathNode succ) {
      bigStep(pred, succ) and
      not getEnclosingCallable(pred) = getEnclosingCallable(succ)
    }

    pragma[nomagic]
    predicate bigStepMaybeLocal(DF::PathNode pred, DF::PathNode succ) {
      bigStep(pred, succ) and
      getEnclosingCallable(pred) = getEnclosingCallable(succ)
    }
  }

  /**
   * Holds if `source` can reach `node`, having read `reads` from the source and
   * written `stores` into `node`.
   *
   * `source` is either a source from a configuration, in which case `scReads` and
   * `scStores` are always empty, or it is the parameter of a summarized callable,
   * in which case `scReads` and `scStores` record the reads/stores for a summary
   * context, that is, the reads/stores for an argument that can reach the parameter.
   */
  pragma[nomagic]
  private predicate nodeReaches(
    DF::PathNode source, AccessPath scReads, AccessPath scStores, DF::PathNode node,
    AccessPath reads, AccessPath stores
  ) {
    exists(ConfigurationAdapter config |
      node = source and
      reads = scReads and
      stores = scStores
    |
      config.hasFlowPath(source, _) and
      scReads = TAccessPathNil() and
      scStores = TAccessPathNil()
      or
      // the argument in a sub path can be reached, so we start flow from the sub path
      // parameter, while recording the read/store summary context
      exists(DF::PathNode arg |
        nodeReachesSubpathArg(_, _, _, arg, scReads, scStores) and
        DF::PathGraph::subpaths(arg, source, _, _)
      )
    )
    or
    exists(DF::PathNode mid |
      nodeReaches(source, scReads, scStores, mid, reads, stores) and
      BigStepFlow::bigStepMaybeLocal(mid, node)
    )
    or
    exists(DF::PathNode mid |
      nodeReaches(source, scReads, scStores, mid, reads, stores) and
      BigStepFlow::bigStepNotLocal(mid, node) and
      // when flow is not local, we cannot flow back out, so we may stop
      // flow early when computing summary flow
      any(ConfigurationAdapter config).hasFlowPath(source, _) and
      scReads = TAccessPathNil() and
      scStores = TAccessPathNil()
    )
    or
    // store step
    exists(AccessPath storesMid, ContentSet c |
      nodeReachesStore(source, scReads, scStores, node, c, reads, storesMid) and
      stores = TAccessPathCons(c, storesMid)
    )
    or
    // read step
    exists(AccessPath readsMid, ContentSet c |
      nodeReachesRead(source, scReads, scStores, node, c, readsMid, stores) and
      reads = TAccessPathCons(c, readsMid)
    )
    or
    // flow-through step; match outer stores/reads with inner store/read summary contexts
    exists(DF::PathNode mid, AccessPath innerScReads, AccessPath innerScStores |
      nodeReachesSubpathArg(source, scReads, scStores, mid, innerScReads, innerScStores) and
      subpathArgReachesOut(mid, innerScReads, innerScStores, node, reads, stores)
    )
  }

  pragma[nomagic]
  private predicate nodeReachesStore(
    DF::PathNode source, AccessPath scReads, AccessPath scStores, DF::PathNode node, ContentSet c,
    AccessPath reads, AccessPath stores
  ) {
    exists(DF::PathNode mid |
      nodeReaches(source, scReads, scStores, mid, reads, stores) and
      storeStep(mid.getNode(), mid.getState(), c, node.getNode(), node.getState(),
        node.getConfiguration()) and
      pathSucc(mid, node)
    )
  }

  pragma[nomagic]
  private predicate nodeReachesRead(
    DF::PathNode source, AccessPath scReads, AccessPath scStores, DF::PathNode node, ContentSet c,
    AccessPath reads, AccessPath stores
  ) {
    exists(DF::PathNode mid |
      nodeReaches(source, scReads, scStores, mid, reads, stores) and
      readStep(mid.getNode(), mid.getState(), c, node.getNode(), node.getState(),
        node.getConfiguration()) and
      pathSucc(mid, node)
    )
  }

  pragma[nomagic]
  private predicate nodeReachesSubpathArg(
    DF::PathNode source, AccessPath scReads, AccessPath scStores, DF::PathNode arg,
    AccessPath reads, AccessPath stores
  ) {
    nodeReaches(source, scReads, scStores, arg, reads, stores) and
    DF::PathGraph::subpaths(arg, _, _, _)
  }

  pragma[nomagic]
  private predicate subpathArgReachesOut(
    DF::PathNode arg, AccessPath scReads, AccessPath scStores, DF::PathNode out, AccessPath reads,
    AccessPath stores
  ) {
    exists(DF::PathNode source, DF::PathNode ret |
      nodeReaches(source, scReads, scStores, ret, reads, stores) and
      DF::PathGraph::subpaths(arg, source, ret, out)
    )
  }
}
