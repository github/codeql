/** Step Summaries and Type Tracking */

private import TypeTrackerSpecific

cached
private module Cached {
  /**
   * A description of a step on an inter-procedural data flow path.
   */
  cached
  newtype TStepSummary =
    LevelStep() or
    CallStep() or
    ReturnStep() or
    StoreStep(TypeTrackerContent content) { basicStoreStep(_, _, content) } or
    LoadStep(TypeTrackerContent content) { basicLoadStep(_, _, content) } or
    LoadStoreStep(TypeTrackerContent load, TypeTrackerContent store) {
      basicLoadStoreStep(_, _, load, store)
    } or
    WithContent(ContentFilter filter) { basicWithContentStep(_, _, filter) } or
    WithoutContent(ContentFilter filter) { basicWithoutContentStep(_, _, filter) } or
    JumpStep()

  cached
  newtype TTypeTracker =
    MkTypeTracker(Boolean hasCall, OptionalTypeTrackerContent content) {
      content = noContent()
      or
      // Restrict `content` to those that might eventually match a load.
      // We can't rely on `basicStoreStep` since `startInContent` might be used with
      // a content that has no corresponding store.
      exists(TypeTrackerContent loadContents |
        (
          basicLoadStep(_, _, loadContents)
          or
          basicLoadStoreStep(_, _, loadContents, _)
        ) and
        compatibleContents(content, loadContents)
      )
    }

  cached
  newtype TTypeBackTracker =
    MkTypeBackTracker(Boolean hasReturn, OptionalTypeTrackerContent content) {
      content = noContent()
      or
      // As in MkTypeTracker, restrict `content` to those that might eventually match a store.
      exists(TypeTrackerContent storeContent |
        (
          basicStoreStep(_, _, storeContent)
          or
          basicLoadStoreStep(_, _, _, storeContent)
        ) and
        compatibleContents(storeContent, content)
      )
    }

  /** Gets a type tracker with no content and the call bit set to the given value. */
  cached
  TypeTracker noContentTypeTracker(boolean hasCall) { result = MkTypeTracker(hasCall, noContent()) }

  /** Gets the summary resulting from appending `step` to type-tracking summary `tt`. */
  cached
  TypeTracker append(TypeTracker tt, StepSummary step) {
    exists(Boolean hasCall, OptionalTypeTrackerContent currentContents |
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
        currentContents = filter.getAMatchingContent()
        or
        step = WithoutContent(filter) and
        not currentContents = filter.getAMatchingContent()
      )
    )
    or
    exists(TypeTrackerContent storeContents, boolean hasCall |
      exists(TypeTrackerContent loadContents |
        step = LoadStep(pragma[only_bind_into](loadContents)) and
        tt = MkTypeTracker(hasCall, storeContents) and
        compatibleContents(storeContents, loadContents) and
        result = noContentTypeTracker(hasCall)
      )
      or
      step = StoreStep(pragma[only_bind_into](storeContents)) and
      tt = noContentTypeTracker(hasCall) and
      result = MkTypeTracker(hasCall, storeContents)
    )
    or
    exists(
      TypeTrackerContent currentContent, TypeTrackerContent store, TypeTrackerContent load,
      boolean hasCall
    |
      step = LoadStoreStep(pragma[only_bind_into](load), pragma[only_bind_into](store)) and
      compatibleContents(pragma[only_bind_into](currentContent), load) and
      tt = MkTypeTracker(pragma[only_bind_into](hasCall), currentContent) and
      result = MkTypeTracker(pragma[only_bind_out](hasCall), store)
    )
  }

  pragma[nomagic]
  private TypeBackTracker noContentTypeBackTracker(boolean hasReturn) {
    result = MkTypeBackTracker(hasReturn, noContent())
  }

  /** Gets the summary resulting from prepending `step` to this type-tracking summary. */
  cached
  TypeBackTracker prepend(TypeBackTracker tbt, StepSummary step) {
    exists(Boolean hasReturn, OptionalTypeTrackerContent content |
      tbt = MkTypeBackTracker(hasReturn, content)
    |
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
        content = filter.getAMatchingContent()
        or
        step = WithoutContent(filter) and
        not content = filter.getAMatchingContent()
      )
    )
    or
    exists(TypeTrackerContent loadContents, boolean hasReturn |
      exists(TypeTrackerContent storeContents |
        step = StoreStep(pragma[only_bind_into](storeContents)) and
        tbt = MkTypeBackTracker(hasReturn, loadContents) and
        compatibleContents(storeContents, loadContents) and
        result = noContentTypeBackTracker(hasReturn)
      )
      or
      step = LoadStep(pragma[only_bind_into](loadContents)) and
      tbt = noContentTypeBackTracker(hasReturn) and
      result = MkTypeBackTracker(hasReturn, loadContents)
    )
    or
    exists(
      TypeTrackerContent currentContent, TypeTrackerContent store, TypeTrackerContent load,
      boolean hasCall
    |
      step = LoadStoreStep(pragma[only_bind_into](load), pragma[only_bind_into](store)) and
      compatibleContents(store, pragma[only_bind_into](currentContent)) and
      tbt = MkTypeBackTracker(pragma[only_bind_into](hasCall), currentContent) and
      result = MkTypeBackTracker(pragma[only_bind_out](hasCall), load)
    )
  }

  /**
   * Gets the summary that corresponds to having taken a forwards
   * heap and/or intra-procedural step from `nodeFrom` to `nodeTo`.
   *
   * Steps contained in this predicate should _not_ depend on the call graph.
   */
  cached
  predicate stepNoCall(TypeTrackingNode nodeFrom, TypeTrackingNode nodeTo, StepSummary summary) {
    exists(Node mid | nodeFrom.flowsTo(mid) and smallstepNoCall(mid, nodeTo, summary))
  }

  /**
   * Gets the summary that corresponds to having taken a forwards
   * inter-procedural step from `nodeFrom` to `nodeTo`.
   */
  cached
  predicate stepCall(TypeTrackingNode nodeFrom, TypeTrackingNode nodeTo, StepSummary summary) {
    exists(Node mid | nodeFrom.flowsTo(mid) and smallstepCall(mid, nodeTo, summary))
  }

  cached
  predicate smallstepNoCall(Node nodeFrom, TypeTrackingNode nodeTo, StepSummary summary) {
    jumpStep(nodeFrom, nodeTo) and
    summary = JumpStep()
    or
    levelStepNoCall(nodeFrom, nodeTo) and
    summary = LevelStep()
    or
    exists(TypeTrackerContent content |
      flowsToStoreStep(nodeFrom, nodeTo, content) and
      summary = StoreStep(content)
      or
      basicLoadStep(nodeFrom, nodeTo, content) and summary = LoadStep(content)
    )
    or
    exists(TypeTrackerContent loadContent, TypeTrackerContent storeContent |
      flowsToLoadStoreStep(nodeFrom, nodeTo, loadContent, storeContent) and
      summary = LoadStoreStep(loadContent, storeContent)
    )
    or
    exists(ContentFilter filter |
      basicWithContentStep(nodeFrom, nodeTo, filter) and
      summary = WithContent(filter)
      or
      basicWithoutContentStep(nodeFrom, nodeTo, filter) and
      summary = WithoutContent(filter)
    )
  }

  cached
  predicate smallstepCall(Node nodeFrom, TypeTrackingNode nodeTo, StepSummary summary) {
    callStep(nodeFrom, nodeTo) and summary = CallStep()
    or
    returnStep(nodeFrom, nodeTo) and
    summary = ReturnStep()
    or
    levelStepCall(nodeFrom, nodeTo) and
    summary = LevelStep()
  }
}

private import Cached

private predicate step(TypeTrackingNode nodeFrom, TypeTrackingNode nodeTo, StepSummary summary) {
  stepNoCall(nodeFrom, nodeTo, summary)
  or
  stepCall(nodeFrom, nodeTo, summary)
}

pragma[nomagic]
private predicate stepProj(TypeTrackingNode nodeFrom, StepSummary summary) {
  step(nodeFrom, _, summary)
}

private predicate smallstep(Node nodeFrom, TypeTrackingNode nodeTo, StepSummary summary) {
  smallstepNoCall(nodeFrom, nodeTo, summary)
  or
  smallstepCall(nodeFrom, nodeTo, summary)
}

pragma[nomagic]
private predicate smallstepProj(Node nodeFrom, StepSummary summary) {
  smallstep(nodeFrom, _, summary)
}

/**
 * Holds if `nodeFrom` is being written to the `content` of the object in `nodeTo`.
 *
 * Note that `nodeTo` will always be a local source node that flows to the place where the content
 * is written in `basicStoreStep`. This may lead to the flow of information going "back in time"
 * from the point of view of the execution of the program.
 *
 * For instance, if we interpret attribute writes in Python as writing to content with the same
 * name as the attribute and consider the following snippet
 *
 * ```python
 * def foo(y):
 *    x = Foo()
 *    bar(x)
 *    x.attr = y
 *    baz(x)
 *
 * def bar(x):
 *    z = x.attr
 * ```
 * for the attribute write `x.attr = y`, we will have `content` being the literal string `"attr"`,
 * `nodeFrom` will be `y`, and `nodeTo` will be the object `Foo()` created on the first line of the
 * function. This means we will track the fact that `x.attr` can have the type of `y` into the
 * assignment to `z` inside `bar`, even though this attribute write happens _after_ `bar` is called.
 */
private predicate flowsToStoreStep(
  Node nodeFrom, TypeTrackingNode nodeTo, TypeTrackerContent content
) {
  exists(Node obj | nodeTo.flowsTo(obj) and basicStoreStep(nodeFrom, obj, content))
}

/**
 * Holds if `loadContent` is loaded from `nodeFrom` and written to `storeContent` of `nodeTo`.
 */
private predicate flowsToLoadStoreStep(
  Node nodeFrom, TypeTrackingNode nodeTo, TypeTrackerContent loadContent,
  TypeTrackerContent storeContent
) {
  exists(Node obj |
    nodeTo.flowsTo(obj) and basicLoadStoreStep(nodeFrom, obj, loadContent, storeContent)
  )
}

/**
 * INTERNAL: Use `TypeTracker` or `TypeBackTracker` instead.
 *
 * A description of a step on an inter-procedural data flow path.
 */
class StepSummary extends TStepSummary {
  /** Gets a textual representation of this step summary. */
  string toString() {
    this instanceof LevelStep and result = "level"
    or
    this instanceof CallStep and result = "call"
    or
    this instanceof ReturnStep and result = "return"
    or
    exists(TypeTrackerContent content | this = StoreStep(content) | result = "store " + content)
    or
    exists(TypeTrackerContent content | this = LoadStep(content) | result = "load " + content)
    or
    exists(TypeTrackerContent load, TypeTrackerContent store |
      this = LoadStoreStep(load, store) and
      result = "load-store " + load + " -> " + store
    )
    or
    this instanceof JumpStep and result = "jump"
  }
}

/** Provides predicates for updating step summaries (`StepSummary`s). */
module StepSummary {
  predicate append = Cached::append/2;

  /**
   * Gets the summary that corresponds to having taken a forwards
   * inter-procedural step from `nodeFrom` to `nodeTo`.
   *
   * This predicate should normally not be used; consider using `step`
   * instead.
   */
  predicate stepCall = Cached::stepCall/3;

  /**
   * Gets the summary that corresponds to having taken a forwards
   * intra-procedural step from `nodeFrom` to `nodeTo`.
   *
   * This predicate should normally not be used; consider using `step`
   * instead.
   */
  predicate stepNoCall = Cached::stepNoCall/3;

  /**
   * Gets the summary that corresponds to having taken a forwards
   * heap and/or inter-procedural step from `nodeFrom` to `nodeTo`.
   */
  predicate step(TypeTrackingNode nodeFrom, TypeTrackingNode nodeTo, StepSummary summary) {
    stepNoCall(nodeFrom, nodeTo, summary)
    or
    stepCall(nodeFrom, nodeTo, summary)
  }

  /**
   * Gets the summary that corresponds to having taken a forwards
   * inter-procedural step from `nodeFrom` to `nodeTo`.
   *
   * This predicate should normally not be used; consider using `step`
   * instead.
   */
  predicate smallstepNoCall = Cached::smallstepNoCall/3;

  /**
   * Gets the summary that corresponds to having taken a forwards
   * intra-procedural step from `nodeFrom` to `nodeTo`.
   *
   * This predicate should normally not be used; consider using `step`
   * instead.
   */
  predicate smallstepCall = Cached::smallstepCall/3;

  /**
   * Gets the summary that corresponds to having taken a forwards
   * local, heap and/or inter-procedural step from `nodeFrom` to `nodeTo`.
   *
   * Unlike `StepSummary::step`, this predicate does not compress
   * type-preserving steps.
   */
  predicate smallstep(Node nodeFrom, TypeTrackingNode nodeTo, StepSummary summary) {
    smallstepNoCall(nodeFrom, nodeTo, summary)
    or
    smallstepCall(nodeFrom, nodeTo, summary)
  }

  deprecated predicate localSourceStoreStep = flowsToStoreStep/3;

  /** Gets the step summary for a level step. */
  StepSummary levelStep() { result = LevelStep() }

  /** Gets the step summary for a call step. */
  StepSummary callStep() { result = CallStep() }

  /** Gets the step summary for a return step. */
  StepSummary returnStep() { result = ReturnStep() }

  /** Gets the step summary for storing into `content`. */
  StepSummary storeStep(TypeTrackerContent content) { result = StoreStep(content) }

  /** Gets the step summary for loading from `content`. */
  StepSummary loadStep(TypeTrackerContent content) { result = LoadStep(content) }

  /** Gets the step summary for loading from `load` and then storing into `store`. */
  StepSummary loadStoreStep(TypeTrackerContent load, TypeTrackerContent store) {
    result = LoadStoreStep(load, store)
  }

  /** Gets the step summary for a step that only permits contents matched by `filter`. */
  StepSummary withContent(ContentFilter filter) { result = WithContent(filter) }

  /** Gets the step summary for a step that blocks contents matched by `filter`. */
  StepSummary withoutContent(ContentFilter filter) { result = WithoutContent(filter) }

  /** Gets the step summary for a jump step. */
  StepSummary jumpStep() { result = JumpStep() }
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
 * DataFlow::TypeTrackingNode myType(DataFlow::TypeTracker t) {
 *   t.start() and
 *   result = < source of myType >
 *   or
 *   exists (DataFlow::TypeTracker t2 |
 *     result = myType(t2).track(t2, t)
 *   )
 * }
 *
 * DataFlow::Node myType() { myType(DataFlow::TypeTracker::end()).flowsTo(result) }
 * ```
 *
 * Instead of `result = myType(t2).track(t2, t)`, you can also use the equivalent
 * `t = t2.step(myType(t2), result)`. If you additionally want to track individual
 * intra-procedural steps, use `t = t2.smallstep(myCallback(t2), result)`.
 */
class TypeTracker extends TTypeTracker {
  Boolean hasCall;
  OptionalTypeTrackerContent content;

  TypeTracker() { this = MkTypeTracker(hasCall, content) }

  /** Gets the summary resulting from appending `step` to this type-tracking summary. */
  TypeTracker append(StepSummary step) { result = append(this, step) }

  /** Gets a textual representation of this summary. */
  string toString() {
    exists(string withCall, string withContent |
      (if hasCall = true then withCall = "with" else withCall = "without") and
      (
        if content != noContent()
        then withContent = " with content " + content
        else withContent = ""
      ) and
      result = "type tracker " + withCall + " call steps" + withContent
    )
  }

  /**
   * Holds if this is the starting point of type tracking.
   */
  predicate start() { hasCall = false and content = noContent() }

  /**
   * Holds if this is the starting point of type tracking, and the value starts in the content named `contentName`.
   * The type tracking only ends after the content has been loaded.
   */
  predicate startInContent(TypeTrackerContent contentName) {
    hasCall = false and content = contentName
  }

  /**
   * Holds if this is the starting point of type tracking
   * when tracking a parameter into a call, but not out of it.
   */
  predicate call() { hasCall = true and content = noContent() }

  /**
   * Holds if this is the end point of type tracking.
   */
  predicate end() { content = noContent() }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Holds if this type has been tracked into a call.
   */
  boolean hasCall() { result = hasCall }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Gets the content associated with this type tracker.
   */
  OptionalTypeTrackerContent getContent() { result = content }

  /**
   * Gets a type tracker that starts where this one has left off to allow continued
   * tracking.
   *
   * This predicate is only defined if the type is not associated to a piece of content.
   */
  TypeTracker continue() { content = noContent() and result = this }

  /**
   * Gets the summary that corresponds to having taken a forwards
   * heap and/or inter-procedural step from `nodeFrom` to `nodeTo`.
   */
  bindingset[nodeFrom, this]
  pragma[inline_late]
  pragma[noopt]
  TypeTracker step(TypeTrackingNode nodeFrom, TypeTrackingNode nodeTo) {
    exists(StepSummary summary |
      stepProj(nodeFrom, summary) and
      result = this.append(summary) and
      step(nodeFrom, nodeTo, summary)
    )
  }

  bindingset[nodeFrom, this]
  pragma[inline_late]
  pragma[noopt]
  private TypeTracker smallstepNoSimpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
    exists(StepSummary summary |
      smallstepProj(nodeFrom, summary) and
      result = this.append(summary) and
      smallstep(nodeFrom, nodeTo, summary)
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
   * DataFlow::Node myType(DataFlow::TypeTracker t) {
   *   t.start() and
   *   result = < source of myType >
   *   or
   *   exists (DataFlow::TypeTracker t2 |
   *     t = t2.smallstep(myType(t2), result)
   *   )
   * }
   *
   * DataFlow::Node myType() {
   *   result = myType(DataFlow::TypeTracker::end())
   * }
   * ```
   */
  pragma[inline]
  TypeTracker smallstep(Node nodeFrom, Node nodeTo) {
    result = this.smallstepNoSimpleLocalFlowStep(nodeFrom, nodeTo)
    or
    simpleLocalFlowStep(nodeFrom, nodeTo) and
    result = this
  }
}

/** Provides predicates for implementing custom `TypeTracker`s. */
module TypeTracker {
  /**
   * Gets a valid end point of type tracking.
   */
  TypeTracker end() { result.end() }

  /**
   * INTERNAL USE ONLY.
   *
   * Gets a valid end point of type tracking with the call bit set to the given value.
   */
  predicate end = Cached::noContentTypeTracker/1;
}

pragma[nomagic]
private predicate backStepProj(TypeTrackingNode nodeTo, StepSummary summary) {
  step(_, nodeTo, summary)
}

private predicate backSmallstepProj(TypeTrackingNode nodeTo, StepSummary summary) {
  smallstep(_, nodeTo, summary)
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
 * DataFlow::TypeTrackingNode myCallback(DataFlow::TypeBackTracker t) {
 *   t.start() and
 *   result = (< some API call >).getArgument(< n >).getALocalSource()
 *   or
 *   exists (DataFlow::TypeBackTracker t2 |
 *     result = myCallback(t2).backtrack(t2, t)
 *   )
 * }
 *
 * DataFlow::TypeTrackingNode myCallback() { result = myCallback(DataFlow::TypeBackTracker::end()) }
 * ```
 *
 * Instead of `result = myCallback(t2).backtrack(t2, t)`, you can also use the equivalent
 * `t2 = t.step(result, myCallback(t2))`. If you additionally want to track individual
 * intra-procedural steps, use `t2 = t.smallstep(result, myCallback(t2))`.
 */
class TypeBackTracker extends TTypeBackTracker {
  Boolean hasReturn;
  OptionalTypeTrackerContent content;

  TypeBackTracker() { this = MkTypeBackTracker(hasReturn, content) }

  /** Gets the summary resulting from prepending `step` to this type-tracking summary. */
  TypeBackTracker prepend(StepSummary step) { result = prepend(this, step) }

  /** Gets a textual representation of this summary. */
  string toString() {
    exists(string withReturn, string withContent |
      (if hasReturn = true then withReturn = "with" else withReturn = "without") and
      (
        if content != noContent()
        then withContent = " with content " + content
        else withContent = ""
      ) and
      result = "type back-tracker " + withReturn + " return steps" + withContent
    )
  }

  /**
   * Holds if this is the starting point of type tracking.
   */
  predicate start() { hasReturn = false and content = noContent() }

  /**
   * Holds if this is the end point of type tracking.
   */
  predicate end() { content = noContent() }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Holds if this type has been back-tracked into a call through return edge.
   */
  boolean hasReturn() { result = hasReturn }

  /**
   * Gets a type tracker that starts where this one has left off to allow continued
   * tracking.
   *
   * This predicate is only defined if the type has not been tracked into a piece of content.
   */
  TypeBackTracker continue() { content = noContent() and result = this }

  /**
   * Gets the summary that corresponds to having taken a backwards
   * heap and/or inter-procedural step from `nodeTo` to `nodeFrom`.
   */
  bindingset[nodeTo, result]
  pragma[inline_late]
  pragma[noopt]
  TypeBackTracker step(TypeTrackingNode nodeFrom, TypeTrackingNode nodeTo) {
    exists(StepSummary summary |
      backStepProj(nodeTo, summary) and
      this = result.prepend(summary) and
      step(nodeFrom, nodeTo, summary)
    )
  }

  bindingset[nodeTo, result]
  pragma[inline_late]
  pragma[noopt]
  private TypeBackTracker smallstepNoSimpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
    exists(StepSummary summary |
      backSmallstepProj(nodeTo, summary) and
      this = result.prepend(summary) and
      smallstep(nodeFrom, nodeTo, summary)
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
   * DataFlow::Node myType(DataFlow::TypeBackTracker t) {
   *   t.start() and
   *   result = < some API call >.getArgument(< n >)
   *   or
   *   exists (DataFlow::TypeBackTracker t2 |
   *     t = t2.smallstep(result, myType(t2))
   *   )
   * }
   *
   * DataFlow::Node myType() {
   *   result = myType(DataFlow::TypeBackTracker::end())
   * }
   * ```
   */
  pragma[inline]
  TypeBackTracker smallstep(Node nodeFrom, Node nodeTo) {
    this = this.smallstepNoSimpleLocalFlowStep(nodeFrom, nodeTo)
    or
    simpleLocalFlowStep(nodeFrom, nodeTo) and
    this = result
  }

  /**
   * Gets a forwards summary that is compatible with this backwards summary.
   * That is, if this summary describes the steps needed to back-track a value
   * from `sink` to `mid`, and the result is a valid summary of the steps needed
   * to track a value from `source` to `mid`, then the value from `source` may
   * also flow to `sink`.
   */
  TypeTracker getACompatibleTypeTracker() {
    exists(boolean hasCall, OptionalTypeTrackerContent c |
      result = MkTypeTracker(hasCall, c) and
      (
        compatibleContents(c, content)
        or
        content = noContent() and c = content
      )
    |
      hasCall = false
      or
      this.hasReturn() = false
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

/**
 * INTERNAL: Do not use.
 *
 * Provides logic for constructing a call graph in mutual recursion with type tracking.
 *
 * When type tracking is used to construct a call graph, we cannot use the join-order
 * from `stepInlineLate`, because `step` becomes a recursive call, which means that we
 * will have a conjunct with 3 recursive calls: the call to `step`, the call to `stepProj`,
 * and the recursive type tracking call itself. The solution is to split the three-way
 * non-linear recursion into two non-linear predicates: one that first joins with the
 * projected `stepCall` relation, followed by a predicate that joins with the full
 * `stepCall` relation (`stepNoCall` not being recursive, can be join-ordered in the
 * same way as in `stepInlineLate`).
 */
module CallGraphConstruction {
  /** The input to call graph construction. */
  signature module InputSig {
    /** A state to track during type tracking. */
    class State;

    /** Holds if type tracking should start at `start` in state `state`. */
    predicate start(Node start, State state);

    /**
     * Holds if type tracking should use the step from `nodeFrom` to `nodeTo`,
     * which _does not_ depend on the call graph.
     *
     * Implementing this predicate using `StepSummary::[small]stepNoCall` yields
     * standard type tracking.
     */
    predicate stepNoCall(Node nodeFrom, Node nodeTo, StepSummary summary);

    /**
     * Holds if type tracking should use the step from `nodeFrom` to `nodeTo`,
     * which _does_ depend on the call graph.
     *
     * Implementing this predicate using `StepSummary::[small]stepCall` yields
     * standard type tracking.
     */
    predicate stepCall(Node nodeFrom, Node nodeTo, StepSummary summary);

    /** A projection of an element from the state space. */
    class StateProj;

    /** Gets the projection of `state`. */
    StateProj stateProj(State state);

    /** Holds if type tracking should stop at `n` when we are tracking projected state `stateProj`. */
    predicate filter(Node n, StateProj stateProj);
  }

  /** Provides the `track` predicate for use in call graph construction. */
  module Make<InputSig Input> {
    pragma[nomagic]
    private predicate stepNoCallProj(Node nodeFrom, StepSummary summary) {
      Input::stepNoCall(nodeFrom, _, summary)
    }

    pragma[nomagic]
    private predicate stepCallProj(Node nodeFrom, StepSummary summary) {
      Input::stepCall(nodeFrom, _, summary)
    }

    bindingset[nodeFrom, t]
    pragma[inline_late]
    pragma[noopt]
    private TypeTracker stepNoCallInlineLate(
      TypeTracker t, TypeTrackingNode nodeFrom, TypeTrackingNode nodeTo
    ) {
      exists(StepSummary summary |
        stepNoCallProj(nodeFrom, summary) and
        result = t.append(summary) and
        Input::stepNoCall(nodeFrom, nodeTo, summary)
      )
    }

    bindingset[state]
    pragma[inline_late]
    private Input::StateProj stateProjInlineLate(Input::State state) {
      result = Input::stateProj(state)
    }

    pragma[nomagic]
    private Node track(Input::State state, TypeTracker t) {
      t.start() and Input::start(result, state)
      or
      exists(Input::StateProj stateProj |
        stateProj = stateProjInlineLate(state) and
        not Input::filter(result, stateProj)
      |
        exists(TypeTracker t2 | t = stepNoCallInlineLate(t2, track(state, t2), result))
        or
        exists(StepSummary summary |
          // non-linear recursion
          Input::stepCall(trackCall(state, t, summary), result, summary)
        )
      )
    }

    bindingset[t, summary]
    pragma[inline_late]
    private TypeTracker appendInlineLate(TypeTracker t, StepSummary summary) {
      result = t.append(summary)
    }

    pragma[nomagic]
    private Node trackCall(Input::State state, TypeTracker t, StepSummary summary) {
      exists(TypeTracker t2 |
        // non-linear recursion
        result = track(state, t2) and
        stepCallProj(result, summary) and
        t = appendInlineLate(t2, summary)
      )
    }

    /** Gets a node that can be reached from _some_ start node in state `state`. */
    pragma[nomagic]
    Node track(Input::State state) { result = track(state, TypeTracker::end()) }
  }

  /** A simple version of `CallGraphConstruction` that uses standard type tracking. */
  module Simple {
    /** The input to call graph construction. */
    signature module InputSig {
      /** A state to track during type tracking. */
      class State;

      /** Holds if type tracking should start at `start` in state `state`. */
      predicate start(Node start, State state);

      /** Holds if type tracking should stop at `n`. */
      predicate filter(Node n);
    }

    /** Provides the `track` predicate for use in call graph construction. */
    module Make<InputSig Input> {
      private module I implements CallGraphConstruction::InputSig {
        private import codeql.util.Unit

        class State = Input::State;

        predicate start(Node start, State state) { Input::start(start, state) }

        predicate stepNoCall(Node nodeFrom, Node nodeTo, StepSummary summary) {
          StepSummary::stepNoCall(nodeFrom, nodeTo, summary)
        }

        predicate stepCall(Node nodeFrom, Node nodeTo, StepSummary summary) {
          StepSummary::stepCall(nodeFrom, nodeTo, summary)
        }

        class StateProj = Unit;

        Unit stateProj(State state) { exists(state) and exists(result) }

        predicate filter(Node n, Unit u) {
          Input::filter(n) and
          exists(u)
        }
      }

      import CallGraphConstruction::Make<I>
    }
  }
}
