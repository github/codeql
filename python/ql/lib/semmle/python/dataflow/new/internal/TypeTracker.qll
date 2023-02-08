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

  pragma[nomagic]
  private TypeTracker noContentTypeTracker(boolean hasCall) {
    result = MkTypeTracker(hasCall, noContent())
  }

  /** Gets the summary resulting from appending `step` to type-tracking summary `tt`. */
  pragma[nomagic]
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
  pragma[nomagic]
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
  /**
   * Gets the summary that corresponds to having taken a forwards
   * heap and/or inter-procedural step from `nodeFrom` to `nodeTo`.
   *
   * This predicate is inlined, which enables better join-orders when
   * the call graph construction and type tracking are mutually recursive.
   * In such cases, non-linear recursion involving `step` will be limited
   * to non-linear recursion for the parts of `step` that involve the
   * call graph.
   */
  pragma[nomagic]
  predicate step(TypeTrackingNode nodeFrom, TypeTrackingNode nodeTo, StepSummary summary) {
    stepNoCall(nodeFrom, nodeTo, summary)
    or
    stepCall(nodeFrom, nodeTo, summary)
  }

  /**
   * Gets the summary that corresponds to having taken a forwards
   * local, heap and/or inter-procedural step from `nodeFrom` to `nodeTo`.
   *
   * Unlike `StepSummary::step`, this predicate does not compress
   * type-preserving steps.
   */
  pragma[nomagic]
  predicate smallstep(Node nodeFrom, TypeTrackingNode nodeTo, StepSummary summary) {
    smallstepNoCall(nodeFrom, nodeTo, summary)
    or
    smallstepCall(nodeFrom, nodeTo, summary)
  }

  deprecated predicate localSourceStoreStep = flowsToStoreStep/3;
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
  TypeTracker step(TypeTrackingNode nodeFrom, TypeTrackingNode nodeTo) {
    exists(StepSummary summary |
      StepSummary::step(pragma[only_bind_out](nodeFrom), _, pragma[only_bind_into](summary)) and
      result = pragma[only_bind_into](pragma[only_bind_out](this)).append(summary) and
      StepSummary::step(pragma[only_bind_into](pragma[only_bind_out](nodeFrom)), nodeTo, summary)
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
  bindingset[nodeFrom, this]
  TypeTracker smallstep(Node nodeFrom, Node nodeTo) {
    exists(StepSummary summary |
      StepSummary::smallstep(pragma[only_bind_out](nodeFrom), _, pragma[only_bind_into](summary)) and
      result = pragma[only_bind_into](pragma[only_bind_out](this)).append(summary) and
      StepSummary::smallstep(pragma[only_bind_into](pragma[only_bind_out](nodeFrom)), nodeTo,
        summary)
    )
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
  bindingset[nodeTo, this]
  TypeBackTracker step(TypeTrackingNode nodeFrom, TypeTrackingNode nodeTo) {
    exists(StepSummary summary |
      StepSummary::step(_, pragma[only_bind_out](nodeTo), pragma[only_bind_into](summary)) and
      result = pragma[only_bind_into](pragma[only_bind_out](this)).prepend(summary) and
      StepSummary::step(nodeFrom, pragma[only_bind_into](pragma[only_bind_out](nodeTo)), summary)
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
  bindingset[nodeTo, this]
  TypeBackTracker smallstep(Node nodeFrom, Node nodeTo) {
    exists(StepSummary summary |
      StepSummary::smallstep(_, pragma[only_bind_out](nodeTo), pragma[only_bind_into](summary)) and
      result = pragma[only_bind_into](pragma[only_bind_out](this)).prepend(summary) and
      StepSummary::smallstep(nodeFrom, pragma[only_bind_into](pragma[only_bind_out](nodeTo)),
        summary)
    )
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
    exists(boolean hasCall | result = MkTypeTracker(hasCall, content) |
      hasCall = false or this.hasReturn() = false
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
