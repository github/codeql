/**
 * Provides classes and predicates for simple data-flow reachability suitable
 * for tracking types.
 */

private import codeql.util.Boolean
private import codeql.util.Option

/**
 * The step relations for type tracking.
 */
signature module TypeTrackingInput {
  /** A node that is used by the type-trackers. */
  class Node {
    /** Gets a textual representation of this node. */
    string toString();
  }

  /**
   * A node that is the source of local flow. This defines the end-points of the
   * big-step relation used by type-trackers once the transitive closure of
   * `simpleLocalFlowStep` is prepended to the other steps.
   */
  class LocalSourceNode extends Node;

  /** A type of content to be used with the store and read steps. */
  class Content {
    /** Gets a textual representation of this content. */
    string toString();
  }

  /**
   * A label to use for `withContentStep` and `withoutContentStep` steps,
   * restricting which `Content`s may pass through.
   */
  class ContentFilter {
    /** Gets the content that matches this filter. */
    Content getAMatchingContent();
  }

  /**
   * Holds if a value stored with `storeContents` can be read back with
   * `loadContents`.
   */
  predicate compatibleContents(Content storeContents, Content loadContents);

  /**
   * Holds if there is a simple local flow step from `nodeFrom` to `nodeTo`.
   * A transitive closure of such steps is prepended to the non-simple
   * type-tracking steps.
   */
  predicate simpleLocalSmallStep(Node nodeFrom, Node nodeTo);

  /**
   * Holds if there is a level step from `nodeFrom` to `nodeTo` that does not
   * depend on the call graph.
   */
  predicate levelStepNoCall(Node nodeFrom, LocalSourceNode nodeTo);

  /**
   * Holds if there is a level step from `nodeFrom` to `nodeTo` that may depend
   * on the call graph.
   */
  predicate levelStepCall(Node nodeFrom, LocalSourceNode nodeTo);

  /**
   * Holds if `nodeFrom` steps to `nodeTo` by being passed as a parameter in a
   * call.
   */
  predicate callStep(Node nodeFrom, LocalSourceNode nodeTo);

  /**
   * Holds if `nodeFrom` steps to `nodeTo` by being returned from a call.
   */
  predicate returnStep(Node nodeFrom, LocalSourceNode nodeTo);

  /**
   * Holds if `nodeFrom` is being written to the content `c` of the object in
   * `nodeTo`.
   */
  predicate storeStep(Node nodeFrom, Node nodeTo, Content c);

  /**
   * Holds if `nodeTo` is the result of accessing the content `c` of `nodeFrom`.
   */
  predicate loadStep(Node nodeFrom, LocalSourceNode nodeTo, Content c);

  /**
   * Holds if the content `c1` of `nodeFrom` is stored in the content `c2` of
   * `nodeTo`.
   */
  predicate loadStoreStep(Node nodeFrom, Node nodeTo, Content c1, Content c2);

  /**
   * Holds if type-tracking should step from `nodeFrom` to `nodeTo` if inside a
   * content matched by `filter`.
   */
  predicate withContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter filter);

  /**
   * Holds if type-tracking should step from `nodeFrom` to `nodeTo` but block
   * flow of contents matched by `filter`.
   */
  predicate withoutContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter filter);

  /**
   * Holds if data can flow from `nodeFrom` to `nodeTo` in a way that discards
   * call contexts.
   */
  predicate jumpStep(Node nodeFrom, LocalSourceNode nodeTo);

  /**
   * Holds if the target of store steps should be backtracked via
   * `simpleLocalSmallStep` to a `LocalSourceNode`. If this flag is not set,
   * then the targets of store steps are assumed to be `LocalSourceNode`s
   * themselves.
   */
  predicate hasFeatureBacktrackStoreTarget();
}

/**
 * Given a set of step relations, this module provides classes and predicates
 * for simple data-flow reachability suitable for tracking types.
 */
module TypeTracking<TypeTrackingInput I> {
  private import I

  /** Provides consistency checks for the type-tracker step relations. */
  module ConsistencyChecks {
    private predicate stepEntry(Node n, string kind) {
      simpleLocalSmallStep(n, _) and kind = "simpleLocalSmallStep"
      or
      exists(StepSummary ss | smallStep(n, _, ss) and kind = ss.toString())
      or
      hasFeatureBacktrackStoreTarget() and
      kind = "storeTarget" and
      (storeStep(_, n, _) or loadStoreStep(_, n, _, _))
    }

    /**
     * Holds if there is any node in a step relation that is unreachable from a
     * `LocalSourceNode`.
     */
    query predicate unreachableNode(string msg) {
      exists(int k, string kind |
        k = strictcount(Node n | stepEntry(n, kind) and not flowsTo(_, n)) and
        msg = "There are " + k + " unreachable nodes in steps of kind " + kind + "."
      )
    }

    /**
     * Holds if there is a store target that isn't a `LocalSourceNode` and
     * backtracking store target feature isn't enabled.
     */
    query predicate nonSourceStoreTarget(string msg) {
      not hasFeatureBacktrackStoreTarget() and
      exists(int k |
        k =
          strictcount(Node n |
            not n instanceof LocalSourceNode and
            (storeStep(_, n, _) or loadStoreStep(_, n, _, _))
          ) and
        msg =
          "There are " + k +
            " store targets that are not local source nodes and backtracking store targets is not enabled."
      )
    }
  }

  private module ContentOption = Option<Content>;

  private class ContentOption = ContentOption::Option;

  private newtype TStepSummary =
    LevelStep() or
    CallStep() or
    ReturnStep() or
    StoreStep(Content content) { storeStep(_, _, content) } or
    LoadStep(Content content) { loadStep(_, _, content) } or
    LoadStoreStep(Content load, Content store) { loadStoreStep(_, _, load, store) } or
    WithContent(ContentFilter filter) { withContentStep(_, _, filter) } or
    WithoutContent(ContentFilter filter) { withoutContentStep(_, _, filter) } or
    JumpStep()

  /**
   * A description of a step on an inter-procedural data flow path.
   */
  private class StepSummary extends TStepSummary {
    /** Gets a textual representation of this step summary. */
    string toString() {
      this instanceof LevelStep and result = "level"
      or
      this instanceof CallStep and result = "call"
      or
      this instanceof ReturnStep and result = "return"
      or
      exists(Content content | this = StoreStep(content) | result = "store " + content)
      or
      exists(Content content | this = LoadStep(content) | result = "load " + content)
      or
      exists(Content load, Content store |
        this = LoadStoreStep(load, store) and
        result = "load-store " + load + " -> " + store
      )
      or
      this instanceof JumpStep and result = "jump"
    }
  }

  private newtype TTypeTracker =
    MkTypeTracker(Boolean hasCall, ContentOption content) {
      content.isNone()
      or
      // Restrict `content` to those that might eventually match a load.
      // We can't rely on `basicStoreStep` since `startInContent` might be used with
      // a content that has no corresponding store.
      exists(Content loadContents |
        (
          loadStep(_, _, loadContents)
          or
          loadStoreStep(_, _, loadContents, _)
        ) and
        compatibleContents(content.asSome(), loadContents)
      )
    }

  private newtype TTypeBackTracker =
    MkTypeBackTracker(Boolean hasReturn, ContentOption content) {
      content.isNone()
      or
      // As in MkTypeTracker, restrict `content` to those that might eventually match a store.
      exists(Content storeContent |
        (
          storeStep(_, _, storeContent)
          or
          loadStoreStep(_, _, _, storeContent)
        ) and
        compatibleContents(storeContent, content.asSome())
      )
    }

  pragma[nomagic]
  private TypeTracker noContentTypeTracker(boolean hasCall) {
    result = MkTypeTracker(hasCall, any(ContentOption::None c))
  }

  pragma[nomagic]
  private TypeTracker contentTypeTracker(boolean hasCall, Content c) {
    result = MkTypeTracker(hasCall, ContentOption::some(c))
  }

  /** Gets the summary resulting from appending `step` to type-tracking summary `tt`. */
  pragma[nomagic]
  private TypeTracker append(TypeTracker tt, StepSummary step) {
    exists(Boolean hasCall, ContentOption currentContents |
      tt = MkTypeTracker(hasCall, currentContents)
    |
      step = LevelStep() and result = tt
      or
      step = CallStep() and result = MkTypeTracker(true, currentContents)
      or
      step = ReturnStep() and hasCall = false and result = tt
      or
      step = JumpStep() and
      result = MkTypeTracker(false, currentContents)
      or
      exists(ContentFilter filter | result = tt |
        step = WithContent(filter) and
        currentContents.asSome() = filter.getAMatchingContent()
        or
        step = WithoutContent(filter) and
        not currentContents.asSome() = filter.getAMatchingContent()
      )
    )
    or
    exists(Content storeContents, boolean hasCall |
      exists(Content loadContents |
        step = LoadStep(pragma[only_bind_into](loadContents)) and
        tt = contentTypeTracker(hasCall, storeContents) and
        compatibleContents(storeContents, loadContents) and
        result = noContentTypeTracker(hasCall)
      )
      or
      step = StoreStep(pragma[only_bind_into](storeContents)) and
      tt = noContentTypeTracker(hasCall) and
      result = contentTypeTracker(hasCall, storeContents)
    )
    or
    exists(Content currentContent, Content store, Content load, boolean hasCall |
      step = LoadStoreStep(pragma[only_bind_into](load), pragma[only_bind_into](store)) and
      compatibleContents(pragma[only_bind_into](currentContent), load) and
      tt = contentTypeTracker(pragma[only_bind_into](hasCall), currentContent) and
      result = contentTypeTracker(pragma[only_bind_out](hasCall), store)
    )
  }

  pragma[nomagic]
  private TypeBackTracker noContentTypeBackTracker(boolean hasReturn) {
    result = MkTypeBackTracker(hasReturn, any(ContentOption::None c))
  }

  pragma[nomagic]
  private TypeBackTracker contentTypeBackTracker(boolean hasReturn, Content c) {
    result = MkTypeBackTracker(hasReturn, ContentOption::some(c))
  }

  /** Gets the summary resulting from prepending `step` to this type-tracking summary. */
  pragma[nomagic]
  private TypeBackTracker prepend(TypeBackTracker tbt, StepSummary step) {
    exists(Boolean hasReturn, ContentOption content | tbt = MkTypeBackTracker(hasReturn, content) |
      step = LevelStep() and result = tbt
      or
      step = CallStep() and hasReturn = false and result = tbt
      or
      step = ReturnStep() and result = MkTypeBackTracker(true, content)
      or
      step = JumpStep() and
      result = MkTypeBackTracker(false, content)
      or
      exists(ContentFilter filter | result = tbt |
        step = WithContent(filter) and
        content.asSome() = filter.getAMatchingContent()
        or
        step = WithoutContent(filter) and
        not content.asSome() = filter.getAMatchingContent()
      )
    )
    or
    exists(Content loadContents, boolean hasReturn |
      exists(Content storeContents |
        step = StoreStep(pragma[only_bind_into](storeContents)) and
        tbt = contentTypeBackTracker(hasReturn, loadContents) and
        compatibleContents(storeContents, loadContents) and
        result = noContentTypeBackTracker(hasReturn)
      )
      or
      step = LoadStep(pragma[only_bind_into](loadContents)) and
      tbt = noContentTypeBackTracker(hasReturn) and
      result = contentTypeBackTracker(hasReturn, loadContents)
    )
    or
    exists(Content currentContent, Content store, Content load, boolean hasCall |
      step = LoadStoreStep(pragma[only_bind_into](load), pragma[only_bind_into](store)) and
      compatibleContents(store, pragma[only_bind_into](currentContent)) and
      tbt = contentTypeBackTracker(pragma[only_bind_into](hasCall), currentContent) and
      result = contentTypeBackTracker(pragma[only_bind_out](hasCall), load)
    )
  }

  pragma[inline]
  private predicate isLocalSourceNode(LocalSourceNode n) { any() }

  /**
   * Holds if there is flow from `localSource` to `dst` using zero or more
   * `simpleLocalSmallStep`s.
   */
  pragma[nomagic]
  predicate flowsTo(LocalSourceNode localSource, Node dst) {
    // explicit type check in base case to avoid repeated type tests in recursive case
    isLocalSourceNode(localSource) and
    dst = localSource
    or
    exists(Node mid |
      flowsTo(localSource, mid) and
      simpleLocalSmallStep(mid, dst)
    )
  }

  pragma[nomagic]
  private predicate storeStepIntoSource(Node nodeFrom, LocalSourceNode nodeTo, Content c) {
    if hasFeatureBacktrackStoreTarget()
    then
      exists(Node obj |
        flowsTo(nodeTo, obj) and
        storeStep(nodeFrom, obj, c)
      )
    else storeStep(nodeFrom, nodeTo, c)
  }

  pragma[nomagic]
  private predicate loadStoreStepIntoSource(
    Node nodeFrom, LocalSourceNode nodeTo, Content c1, Content c2
  ) {
    if hasFeatureBacktrackStoreTarget()
    then
      exists(Node obj |
        flowsTo(nodeTo, obj) and
        loadStoreStep(nodeFrom, obj, c1, c2)
      )
    else loadStoreStep(nodeFrom, nodeTo, c1, c2)
  }

  pragma[nomagic]
  private predicate smallStepNoCall(Node nodeFrom, LocalSourceNode nodeTo, StepSummary summary) {
    levelStepNoCall(nodeFrom, nodeTo) and summary = LevelStep()
    or
    exists(Content content |
      storeStepIntoSource(nodeFrom, nodeTo, content) and
      summary = StoreStep(content)
    )
    or
    exists(Content content |
      loadStep(nodeFrom, nodeTo, content) and
      summary = LoadStep(content)
    )
    or
    exists(Content content1, Content content2 |
      loadStoreStepIntoSource(nodeFrom, nodeTo, content1, content2) and
      summary = LoadStoreStep(content1, content2)
    )
    or
    exists(ContentFilter filter |
      withContentStep(nodeFrom, nodeTo, filter) and
      summary = WithContent(filter)
    )
    or
    exists(ContentFilter filter |
      withoutContentStep(nodeFrom, nodeTo, filter) and
      summary = WithoutContent(filter)
    )
    or
    jumpStep(nodeFrom, nodeTo) and summary = JumpStep()
  }

  pragma[nomagic]
  private predicate smallStepCall(Node nodeFrom, LocalSourceNode nodeTo, StepSummary summary) {
    levelStepCall(nodeFrom, nodeTo) and summary = LevelStep()
    or
    callStep(nodeFrom, nodeTo) and summary = CallStep()
    or
    returnStep(nodeFrom, nodeTo) and summary = ReturnStep()
  }

  pragma[nomagic]
  private predicate stepNoCall(LocalSourceNode nodeFrom, LocalSourceNode nodeTo, StepSummary summary) {
    exists(Node mid | flowsTo(nodeFrom, mid) and smallStepNoCall(mid, nodeTo, summary))
  }

  pragma[nomagic]
  private predicate stepCall(LocalSourceNode nodeFrom, LocalSourceNode nodeTo, StepSummary summary) {
    exists(Node mid | flowsTo(nodeFrom, mid) and smallStepCall(mid, nodeTo, summary))
  }

  pragma[inline]
  private predicate smallStepSplit(Node nodeFrom, LocalSourceNode nodeTo, StepSummary summary) {
    smallStepCall(nodeFrom, nodeTo, summary) or smallStepNoCall(nodeFrom, nodeTo, summary)
  }

  pragma[inline]
  private predicate stepSplit(LocalSourceNode nodeFrom, LocalSourceNode nodeTo, StepSummary summary) {
    stepNoCall(nodeFrom, nodeTo, summary) or stepCall(nodeFrom, nodeTo, summary)
  }

  pragma[nomagic]
  private predicate smallStep(Node nodeFrom, LocalSourceNode nodeTo, StepSummary summary) {
    smallStepSplit(nodeFrom, nodeTo, summary)
  }

  pragma[nomagic]
  private predicate step(LocalSourceNode nodeFrom, LocalSourceNode nodeTo, StepSummary summary) {
    stepSplit(nodeFrom, nodeTo, summary)
  }

  /**
   * A summary of the steps needed to track a value to a given dataflow node.
   *
   * This can be used to track objects that implement a certain API in order to
   * recognize calls to that API. Note that type-tracking does not by itself provide a
   * source/sink relation, that is, it may determine that a node has a given type,
   * but it won't determine where that type came from.
   *
   * It is recommended that all uses of this type are written in the following form,
   * for tracking some type `myType`:
   * ```ql
   * Node myType(TypeTracker tt) {
   *   tt.start() and
   *   result = < source of myType >
   *   or
   *   exists(TypeTracker tt2 |
   *     tt = tt2.step(myType(tt2), result)
   *   )
   * }
   *
   * Node myType() { myType(TypeTracker::end()).flowsTo(result) }
   * ```
   *
   * If you want to track individual intra-procedural steps, use `tt2.smallstep`
   * instead of `tt2.step`.
   */
  class TypeTracker extends TTypeTracker {
    private Boolean hasCall;
    private ContentOption content;

    TypeTracker() { this = MkTypeTracker(hasCall, content) }

    /** Gets the summary resulting from appending `step` to this type-tracking summary. */
    private TypeTracker append(StepSummary step) { result = append(this, step) }

    /** Gets a textual representation of this summary. */
    string toString() {
      exists(string withCall, string withContent |
        (if hasCall = true then withCall = "with" else withCall = "without") and
        (
          withContent = " with content " + content.asSome()
          or
          content instanceof ContentOption::None and
          withContent = ""
        ) and
        result = "type tracker " + withCall + " call steps" + withContent
      )
    }

    /**
     * Holds if this is the starting point of type tracking.
     */
    predicate start() { hasCall = false and content.isNone() }

    /**
     * Holds if this is the starting point of type tracking, and the value starts in the content named `contentName`.
     * The type tracking only ends after the content has been loaded.
     */
    predicate startInContent(Content contentName) {
      hasCall = false and content = ContentOption::some(contentName)
    }

    /**
     * Holds if this is the starting point of type tracking
     * when tracking a parameter into a call, but not out of it.
     */
    predicate call() { hasCall = true and content.isNone() }

    /**
     * Holds if this is the end point of type tracking.
     */
    predicate end() { content.isNone() }

    /**
     * INTERNAL. DO NOT USE.
     *
     * Gets the content associated with this type tracker.
     */
    ContentOption getContent() { result = content }

    /**
     * Gets a type tracker that starts where this one has left off to allow continued
     * tracking.
     *
     * This predicate is only defined if the type is not associated to a piece of content.
     */
    TypeTracker continue() { content.isNone() and result = this }

    /**
     * Gets the summary that corresponds to having taken a forwards
     * heap and/or inter-procedural step from `nodeFrom` to `nodeTo`.
     */
    bindingset[nodeFrom, this]
    TypeTracker step(LocalSourceNode nodeFrom, LocalSourceNode nodeTo) {
      exists(StepSummary summary |
        step(pragma[only_bind_out](nodeFrom), _, pragma[only_bind_into](summary)) and
        result = pragma[only_bind_into](pragma[only_bind_out](this)).append(summary) and
        step(pragma[only_bind_into](pragma[only_bind_out](nodeFrom)), nodeTo, summary)
      )
    }

    /**
     * Gets the summary that corresponds to having taken a forwards
     * local, heap and/or inter-procedural step from `nodeFrom` to `nodeTo`.
     *
     * Unlike `TypeTracker::step`, this predicate exposes all edges
     * in the flow graph, and not just the edges between `Node`s.
     * It may therefore be less performant.
     *
     * Type tracking predicates using small steps typically take the following form:
     * ```ql
     * Node myType(TypeTracker tt) {
     *   tt.start() and
     *   result = < source of myType >
     *   or
     *   exists(TypeTracker tt2 |
     *     tt = tt2.smallstep(myType(tt2), result)
     *   )
     * }
     *
     * Node myType() {
     *   result = myType(TypeTracker::end())
     * }
     * ```
     */
    bindingset[nodeFrom, this]
    TypeTracker smallstep(Node nodeFrom, Node nodeTo) {
      exists(StepSummary summary |
        smallStep(pragma[only_bind_out](nodeFrom), _, pragma[only_bind_into](summary)) and
        result = pragma[only_bind_into](pragma[only_bind_out](this)).append(summary) and
        smallStep(pragma[only_bind_into](pragma[only_bind_out](nodeFrom)), nodeTo, summary)
      )
      or
      simpleLocalSmallStep(nodeFrom, nodeTo) and
      result = this
    }
  }

  /** Provides predicates for implementing custom `TypeTracker`s. */
  module TypeTracker {
    /**
     * Gets a valid end point of type tracking.
     */
    TypeTracker end() { result.end() }
  }

  /**
   * A summary of the steps needed to back-track a use of a value to a given dataflow node.
   *
   * This can for example be used to track callbacks that are passed to a certain API,
   * so we can model specific parameters of that callback as having a certain type.
   *
   * Note that type back-tracking does not provide a source/sink relation, that is,
   * it may determine that a node will be used in an API call somewhere, but it won't
   * determine exactly where that use was, or the path that led to the use.
   *
   * It is recommended that all uses of this type are written in the following form,
   * for back-tracking some callback type `myCallback`:
   *
   * ```ql
   * Node myCallback(TypeBackTracker t) {
   *   t.start() and
   *   result = (< some API call >).getArgument(< n >).getALocalSource()
   *   or
   *   exists(TypeBackTracker t2 |
   *     t = t2.step(result, myCallback(t2))
   *   )
   * }
   *
   * Node myCallback() { result = myCallback(TypeBackTracker::end()) }
   * ```
   *
   * If you want to track individual intra-procedural steps, use `t2.smallstep`
   * instead of `t2.step`.
   */
  class TypeBackTracker extends TTypeBackTracker {
    private Boolean hasReturn;
    private ContentOption content;

    TypeBackTracker() { this = MkTypeBackTracker(hasReturn, content) }

    /** Gets the summary resulting from prepending `step` to this type-tracking summary. */
    private TypeBackTracker prepend(StepSummary step) { result = prepend(this, step) }

    /** Gets a textual representation of this summary. */
    string toString() {
      exists(string withReturn, string withContent |
        (if hasReturn = true then withReturn = "with" else withReturn = "without") and
        (
          withContent = " with content " + content.asSome()
          or
          content instanceof ContentOption::None and
          withContent = ""
        ) and
        result = "type back-tracker " + withReturn + " return steps" + withContent
      )
    }

    /**
     * Holds if this is the starting point of type tracking.
     */
    predicate start() { hasReturn = false and content.isNone() }

    /**
     * Holds if this is the end point of type tracking.
     */
    predicate end() { content.isNone() }

    /**
     * Gets a type tracker that starts where this one has left off to allow continued
     * tracking.
     *
     * This predicate is only defined if the type has not been tracked into a piece of content.
     */
    TypeBackTracker continue() { content.isNone() and result = this }

    /**
     * Gets the summary that corresponds to having taken a backwards
     * heap and/or inter-procedural step from `nodeTo` to `nodeFrom`.
     */
    bindingset[nodeTo, this]
    TypeBackTracker step(LocalSourceNode nodeFrom, LocalSourceNode nodeTo) {
      exists(StepSummary summary |
        step(_, pragma[only_bind_out](nodeTo), pragma[only_bind_into](summary)) and
        result = pragma[only_bind_into](pragma[only_bind_out](this)).prepend(summary) and
        step(nodeFrom, pragma[only_bind_into](pragma[only_bind_out](nodeTo)), summary)
      )
    }

    /**
     * Gets the summary that corresponds to having taken a backwards
     * local, heap and/or inter-procedural step from `nodeTo` to `nodeFrom`.
     *
     * Unlike `TypeBackTracker::step`, this predicate exposes all edges
     * in the flowgraph, and not just the edges between
     * `TypeTrackingNode`s. It may therefore be less performant.
     *
     * Type tracking predicates using small steps typically take the following form:
     * ```ql
     * Node myType(TypeBackTracker t) {
     *   t.start() and
     *   result = < some API call >.getArgument(< n >)
     *   or
     *   exists (TypeBackTracker t2 |
     *     t = t2.smallstep(result, myType(t2))
     *   )
     * }
     *
     * Node myType() {
     *   result = myType(DataFlow::TypeBackTracker::end())
     * }
     * ```
     */
    bindingset[nodeTo, this]
    TypeBackTracker smallstep(Node nodeFrom, Node nodeTo) {
      exists(StepSummary summary |
        smallStep(_, pragma[only_bind_out](nodeTo), pragma[only_bind_into](summary)) and
        result = pragma[only_bind_into](pragma[only_bind_out](this)).prepend(summary) and
        smallStep(nodeFrom, pragma[only_bind_into](pragma[only_bind_out](nodeTo)), summary)
      )
      or
      simpleLocalSmallStep(nodeFrom, nodeTo) and
      result = this
    }

    /**
     * Gets a forwards summary that is compatible with this backwards summary.
     * That is, if this summary describes the steps needed to back-track a value
     * from `sink` to `mid`, and the result is a valid summary of the steps needed
     * to track a value from `source` to `mid`, then the value from `source` may
     * also flow to `sink`.
     */
    TypeTracker getACompatibleTypeTracker() {
      exists(boolean hasCall | result = MkTypeTracker(hasCall, content) |
        hasCall = false or hasReturn = false
      )
    }
  }

  /** Provides predicates for implementing custom `TypeBackTracker`s. */
  module TypeBackTracker {
    /**
     * Gets a valid end point of type back-tracking.
     */
    TypeBackTracker end() { result.end() }
  }

  signature predicate endpoint(Node node);

  /**
   * Given a source definition, constructs the default forward type tracking from
   * those sources.
   */
  module TypeTrack<endpoint/1 source> {
    pragma[assume_small_delta]
    private Node flow(TypeTracker tt) {
      tt.start() and source(result)
      or
      exists(TypeTracker ttMid | tt = ttMid.step(flow(ttMid), result))
    }

    /**
     * Holds if the given source flows to `n`.
     */
    predicate flowsTo(Node n) { flowsTo(flow(TypeTracker::end()), n) }

    /**
     * Given a sink definition, constructs the relation of edges that can be used
     * in a source-sink path and calculates the set of source-sink pairs.
     */
    module Graph<endpoint/1 sink> {
      private newtype TPathNode =
        TPathNodeMid(Node node, TypeTracker tt) { node = flow(tt) } or
        TPathNodeSink(Node node) { sink(node) and flowsTo(node) }

      /**
       * A node on a path that is reachable from a source. This is a pair of a
       * `Node` and a `TypeTracker` except at sinks for which there is no `TypeTracker`.
       */
      class PathNodeFwd extends TPathNode {
        /** Gets the node of this `PathNode`. */
        Node getNode() { this = TPathNodeMid(result, _) or this = TPathNodeSink(result) }

        /** Gets the typetracker of this `PathNode`, if any. */
        TypeTracker getTypeTracker() { this = TPathNodeMid(_, result) }

        private string ppContent() {
          exists(ContentOption c | this.getTypeTracker() = MkTypeTracker(_, c) |
            result = " with content " + c.asSome()
            or
            c instanceof ContentOption::None and
            result = ""
          )
          or
          result = "" and this instanceof TPathNodeSink
        }

        /** Gets a textual representation of this node. */
        string toString() { result = this.getNode().toString() + this.ppContent() }

        /** Holds if this is a source. */
        predicate isSource() { source(this.getNode()) and this.getTypeTracker().start() }

        /** Holds if this is a sink. */
        predicate isSink() { this instanceof TPathNodeSink }
      }

      private predicate edgeCand(Node n1, TypeTracker tt1, Node n2, TypeTracker tt2) {
        n1 = flow(tt1) and
        tt2 = tt1.step(n1, n2)
      }

      private predicate edgeCand(PathNodeFwd n1, PathNodeFwd n2) {
        exists(PathNodeFwd tgt |
          edgeCand(n1.getNode(), n1.getTypeTracker(), tgt.getNode(), tgt.getTypeTracker())
        |
          n2 = tgt
          or
          n2 = TPathNodeSink(tgt.getNode()) and tgt.getTypeTracker().end()
        )
        or
        n1.getTypeTracker().end() and
        flowsTo(n1.getNode(), n2.getNode()) and
        n2 instanceof TPathNodeSink
      }

      private predicate reachRev(PathNodeFwd n) {
        n.isSink()
        or
        exists(PathNodeFwd mid |
          edgeCand(n, mid) and
          reachRev(mid)
        )
      }

      /**
       * A node on a path that is reachable from a source and can reach a sink.
       * This is a pair of a `Node` and a `TypeTracker`.
       */
      class PathNode extends PathNodeFwd {
        PathNode() { reachRev(this) }
      }

      /** Holds if `(p1, p2)` is an edge in a path between a source and a sink. */
      query predicate edges(PathNode n1, PathNode n2) { edgeCand(n1, n2) }

      private predicate stepPlus(PathNode n1, PathNode n2) = fastTC(edges/2)(n1, n2)

      /** Holds if there is a path between `source` and `sink`. */
      predicate hasFlow(PathNode source, PathNode sink) {
        source.isSource() and
        sink.isSink() and
        (source = sink or stepPlus(source, sink))
      }
    }
  }
}
