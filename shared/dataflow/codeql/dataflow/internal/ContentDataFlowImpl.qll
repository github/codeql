/**
 * Provides classes for performing global (inter-procedural)
 * content-sensitive data flow analyses.
 *
 * Unlike `DataFlow::Global`, we allow for data to be stored (possibly nested) inside
 * contents of sources and sinks.
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

private import codeql.dataflow.DataFlow
private import codeql.util.Boolean
private import codeql.util.Location

module MakeImplContentDataFlow<LocationSig Location, InputSig<Location> Lang> {
  private import Lang
  private import DataFlowMake<Location, Lang>
  private import DataFlowImplCommon::MakeImplCommon<Location, Lang>

  /**
   * An input configuration for content data flow.
   */
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
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
     */
    default predicate isAdditionalFlowStep(Node node1, Node node2) { none() }

    /** Holds if data flow into `node` is prohibited. */
    default predicate isBarrier(Node node) { none() }

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
    default FlowFeature getAFeature() { none() }

    /** Gets a limit on the number of reads out of sources and number of stores into sinks. */
    default int accessPathLimit() { result = Lang::accessPathLimit() }

    /** Holds if `c` is relevant for reads out of sources or stores into sinks. */
    default predicate isRelevantContent(ContentSet c) { any() }
  }

  /**
   * Constructs a global content data flow computation.
   */
  module Global<ConfigSig ContentConfig> {
    private module FlowConfig implements StateConfigSig {
      class FlowState = State;

      predicate isSource(Node source, FlowState state) {
        ContentConfig::isSource(source) and
        state.(InitState).decode(true)
      }

      predicate isSink(Node sink, FlowState state) {
        ContentConfig::isSink(sink) and
        (
          state instanceof InitState or
          state instanceof StoreState or
          state instanceof ReadState
        )
      }

      predicate isAdditionalFlowStep(Node node1, FlowState state1, Node node2, FlowState state2) {
        storeStep(node1, state1, _, node2, state2) or
        readStep(node1, state1, _, node2, state2) or
        additionalStep(node1, state1, node2, state2)
      }

      predicate isBarrier = ContentConfig::isBarrier/1;

      FlowFeature getAFeature() { result = ContentConfig::getAFeature() }

      predicate accessPathLimit = ContentConfig::accessPathLimit/0;

      // needed to record reads/stores inside summarized callables
      predicate includeHiddenNodes() { any() }
    }

    private module Flow = GlobalWithState<FlowConfig>;

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
    predicate flow(
      Node source, AccessPath sourceAp, Node sink, AccessPath sinkAp, boolean preservesValue
    ) {
      exists(Flow::PathNode pathSource, Flow::PathNode pathSink |
        Flow::flowPath(pathSource, pathSink) and
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

    private newtype TState =
      TInitState(Boolean preservesValue) or
      TStoreState(int size, Boolean preservesValue) {
        size in [1 .. ContentConfig::accessPathLimit()]
      } or
      TReadState(int size, Boolean preservesValue) {
        size in [1 .. ContentConfig::accessPathLimit()]
      }

    abstract private class State extends TState {
      abstract string toString();
    }

    /** A flow state representing no reads or stores. */
    private class InitState extends State, TInitState {
      private boolean preservesValue_;

      InitState() { this = TInitState(preservesValue_) }

      override string toString() { result = "Init(" + preservesValue_ + ")" }

      predicate decode(boolean preservesValue) { preservesValue = preservesValue_ }
    }

    /** A flow state representing that content has been stored into. */
    private class StoreState extends State, TStoreState {
      private boolean preservesValue_;
      private int size_;

      StoreState() { this = TStoreState(size_, preservesValue_) }

      override string toString() { result = "StoreState(" + size_ + "," + preservesValue_ + ")" }

      predicate decode(int size, boolean preservesValue) {
        size = size_ and preservesValue = preservesValue_
      }
    }

    /** A flow state representing that content has been read from. */
    private class ReadState extends State, TReadState {
      private boolean preservesValue_;
      private int size_;

      ReadState() { this = TReadState(size_, preservesValue_) }

      override string toString() { result = "ReadState(" + size_ + "," + preservesValue_ + ")" }

      predicate decode(int size, boolean preservesValue) {
        size = size_ and preservesValue = preservesValue_
      }
    }

    private predicate storeStep(
      Node node1, State state1, ContentSet c, Node node2, StoreState state2
    ) {
      exists(boolean preservesValue, int size |
        storeSet(node1, c, node2, _, _) and
        ContentConfig::isRelevantContent(c) and
        state2.decode(size + 1, preservesValue)
      |
        state1.(InitState).decode(preservesValue) and size = 0
        or
        state1.(ReadState).decode(_, preservesValue) and size = 0
        or
        state1.(StoreState).decode(size, preservesValue)
      )
    }

    private predicate readStep(Node node1, State state1, ContentSet c, Node node2, ReadState state2) {
      exists(int size |
        readSet(node1, c, node2) and
        ContentConfig::isRelevantContent(c) and
        state2.decode(size + 1, true)
      |
        state1.(InitState).decode(true) and
        size = 0
        or
        state1.(ReadState).decode(size, true)
      )
    }

    private predicate additionalStep(Node node1, State state1, Node node2, State state2) {
      ContentConfig::isAdditionalFlowStep(node1, node2) and
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

      /**
       * Gets the content set at index `i` in this access path, if any.
       */
      ContentSet getAtIndex(int i) {
        i = 0 and
        result = this.getHead()
        or
        i > 0 and
        result = this.getTail().getAtIndex(i - 1)
      }

      private AccessPath reverse0(int i) {
        i = -1 and result = TAccessPathNil()
        or
        i >= 0 and
        result = TAccessPathCons(this.getAtIndex(i), this.reverse0(i - 1))
      }
    }

    /**
     * Provides a big-step flow relation, where flow stops at read/store steps that
     * must be recorded, and flow via `subpaths` such that reads/stores inside
     * summarized callables can be recorded as well.
     */
    private module BigStepFlow {
      private predicate reachesSink(Flow::PathNode node) {
        FlowConfig::isSink(node.getNode(), node.getState())
        or
        reachesSink(node.getASuccessor())
      }

      /**
       * Holds if the flow step `pred -> succ` should not be allowed to be included
       * in the big-step relation.
       */
      pragma[nomagic]
      private predicate excludeStep(Flow::PathNode pred, Flow::PathNode succ) {
        pred.getASuccessor() = succ and
        (
          // we need to record reads/stores inside summarized callables
          Flow::PathGraph::subpaths(pred, _, _, succ)
          or
          // only allow flow into a summarized callable, as part of the big-step
          // relation, when flow can reach a sink without going back out
          Flow::PathGraph::subpaths(pred, succ, _, _) and
          not reachesSink(succ)
        )
        or
        exists(Node predNode, State predState, Node succNode, State succState |
          succNodeAndState(pred, predNode, predState, succ, succNode, succState)
        |
          // needed to record store steps
          storeStep(predNode, predState, _, succNode, succState)
          or
          // needed to record read steps
          readStep(predNode, predState, _, succNode, succState)
        )
      }

      pragma[nomagic]
      private DataFlowCallable getEnclosingCallableImpl(Flow::PathNode node) {
        result = getNodeEnclosingCallable(node.getNode())
      }

      pragma[inline]
      private DataFlowCallable getEnclosingCallable(Flow::PathNode node) {
        pragma[only_bind_into](result) = getEnclosingCallableImpl(pragma[only_bind_out](node))
      }

      pragma[nomagic]
      private predicate bigStepEntry(Flow::PathNode node) {
        (
          FlowConfig::isSource(node.getNode(), node.getState())
          or
          excludeStep(_, node)
          or
          Flow::PathGraph::subpaths(_, node, _, _)
        )
      }

      pragma[nomagic]
      private predicate bigStepExit(Flow::PathNode node) {
        (
          bigStepEntry(node)
          or
          FlowConfig::isSink(node.getNode(), node.getState())
          or
          excludeStep(node, _)
          or
          Flow::PathGraph::subpaths(_, _, node, _)
        )
      }

      pragma[nomagic]
      private predicate step(Flow::PathNode pred, Flow::PathNode succ) {
        pred.getASuccessor() = succ and
        not excludeStep(pred, succ)
      }

      pragma[nomagic]
      private predicate stepRec(Flow::PathNode pred, Flow::PathNode succ) {
        step(pred, succ) and
        not bigStepEntry(pred)
      }

      private predicate stepRecPlus(Flow::PathNode n1, Flow::PathNode n2) =
        fastTC(stepRec/2)(n1, n2)

      /**
       * Holds if there is flow `pathSucc+(pred) = succ`, and such a flow path does
       * not go through any reads/stores that need to be recorded, or summarized
       * steps.
       */
      pragma[nomagic]
      private predicate bigStep(Flow::PathNode pred, Flow::PathNode succ) {
        exists(Flow::PathNode mid |
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
      predicate bigStepNotLocal(Flow::PathNode pred, Flow::PathNode succ) {
        bigStep(pred, succ) and
        not getEnclosingCallable(pred) = getEnclosingCallable(succ)
      }

      pragma[nomagic]
      predicate bigStepMaybeLocal(Flow::PathNode pred, Flow::PathNode succ) {
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
      Flow::PathNode source, AccessPath scReads, AccessPath scStores, Flow::PathNode node,
      AccessPath reads, AccessPath stores
    ) {
      node = source and
      reads = scReads and
      stores = scStores and
      (
        Flow::flowPath(source, _) and
        scReads = TAccessPathNil() and
        scStores = TAccessPathNil()
        or
        // the argument in a sub path can be reached, so we start flow from the sub path
        // parameter, while recording the read/store summary context
        exists(Flow::PathNode arg |
          nodeReachesSubpathArg(_, _, _, arg, scReads, scStores) and
          Flow::PathGraph::subpaths(arg, source, _, _)
        )
      )
      or
      exists(Flow::PathNode mid |
        nodeReaches(source, scReads, scStores, mid, reads, stores) and
        BigStepFlow::bigStepMaybeLocal(mid, node)
      )
      or
      exists(Flow::PathNode mid |
        nodeReaches(source, scReads, scStores, mid, reads, stores) and
        BigStepFlow::bigStepNotLocal(mid, node) and
        // when flow is not local, we cannot flow back out, so we may stop
        // flow early when computing summary flow
        Flow::flowPath(source, _) and
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
      exists(Flow::PathNode mid, AccessPath innerScReads, AccessPath innerScStores |
        nodeReachesSubpathArg(source, scReads, scStores, mid, innerScReads, innerScStores) and
        subpathArgReachesOut(mid, innerScReads, innerScStores, node, reads, stores)
      )
    }

    pragma[nomagic]
    private predicate succNodeAndState(
      Flow::PathNode pre, Node preNode, State preState, Flow::PathNode succ, Node succNode,
      State succState
    ) {
      pre.getNode() = preNode and
      pre.getState() = preState and
      succ.getNode() = succNode and
      succ.getState() = succState and
      pre.getASuccessor() = succ
    }

    pragma[nomagic]
    private predicate nodeReachesStore(
      Flow::PathNode source, AccessPath scReads, AccessPath scStores, Flow::PathNode target,
      ContentSet c, AccessPath reads, AccessPath stores
    ) {
      exists(Flow::PathNode mid, State midState, Node midNode, State targetState, Node targetNode |
        nodeReaches(source, scReads, scStores, mid, reads, stores) and
        succNodeAndState(mid, midNode, midState, target, targetNode, targetState) and
        storeStep(midNode, midState, c, targetNode, targetState)
      )
    }

    pragma[nomagic]
    private predicate nodeReachesRead(
      Flow::PathNode source, AccessPath scReads, AccessPath scStores, Flow::PathNode target,
      ContentSet c, AccessPath reads, AccessPath stores
    ) {
      exists(Flow::PathNode mid, State midState, Node midNode, State targetState, Node targetNode |
        nodeReaches(source, scReads, scStores, mid, reads, stores) and
        succNodeAndState(mid, midNode, midState, target, targetNode, targetState) and
        readStep(midNode, midState, c, targetNode, targetState)
      )
    }

    pragma[nomagic]
    private predicate nodeReachesSubpathArg(
      Flow::PathNode source, AccessPath scReads, AccessPath scStores, Flow::PathNode arg,
      AccessPath reads, AccessPath stores
    ) {
      nodeReaches(source, scReads, scStores, arg, reads, stores) and
      Flow::PathGraph::subpaths(arg, _, _, _)
    }

    pragma[nomagic]
    private predicate subpathArgReachesOut(
      Flow::PathNode arg, AccessPath scReads, AccessPath scStores, Flow::PathNode out,
      AccessPath reads, AccessPath stores
    ) {
      exists(Flow::PathNode source, Flow::PathNode ret |
        nodeReaches(source, scReads, scStores, ret, reads, stores) and
        Flow::PathGraph::subpaths(arg, source, ret, out)
      )
    }
  }
}
