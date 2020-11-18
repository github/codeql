/** Step Summaries and Type Tracking */

private import python
private import internal.DataFlowPublic
private import internal.DataFlowPrivate

/** Any string that may appear as the name of an attribute or access path. */
class AttributeName extends string {
  AttributeName() { this = any(AttrRef a).getAttributeName() }
}

/** Either an attribute name, or the empty string (representing no attribute). */
class OptionalAttributeName extends string {
  OptionalAttributeName() { this instanceof AttributeName or this = "" }
}

/**
 * A description of a step on an inter-procedural data flow path.
 */
private newtype TStepSummary =
  LevelStep() or
  CallStep() or
  ReturnStep() or
  StoreStep(AttributeName attr) or
  LoadStep(AttributeName attr)

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
    exists(string attr | this = StoreStep(attr) | result = "store " + attr)
    or
    exists(string attr | this = LoadStep(attr) | result = "load " + attr)
  }
}

/** Provides predicates for updating step summaries (`StepSummary`s). */
module StepSummary {
  /**
   * Gets the summary that corresponds to having taken a forwards
   * heap and/or inter-procedural step from `nodeFrom` to `nodeTo`.
   */
  cached
  predicate step(Node nodeFrom, Node nodeTo, StepSummary summary) {
    exists(Node mid | typePreservingStep*(nodeFrom, mid) and smallstep(mid, nodeTo, summary))
  }

  /**
   * Gets the summary that corresponds to having taken a forwards
   * local, heap and/or inter-procedural step from `nodeFrom` to `nodeTo`.
   *
   * Unlike `StepSummary::step`, this predicate does not compress
   * type-preserving steps.
   */
  predicate smallstep(Node nodeFrom, Node nodeTo, StepSummary summary) {
    typePreservingStep(nodeFrom, nodeTo) and
    summary = LevelStep()
    or
    callStep(nodeFrom, nodeTo) and summary = CallStep()
    or
    returnStep(nodeFrom, nodeTo) and
    summary = ReturnStep()
    or
    exists(string attr |
      basicStoreStep(nodeFrom, nodeTo, attr) and
      summary = StoreStep(attr)
      or
      basicLoadStep(nodeFrom, nodeTo, attr) and summary = LoadStep(attr)
    )
  }
}

/** Holds if it's reasonable to expect the data flow step from `nodeFrom` to `nodeTo` to preserve types. */
private predicate typePreservingStep(Node nodeFrom, Node nodeTo) {
  EssaFlow::essaFlowStep(nodeFrom, nodeTo) or
  jumpStep(nodeFrom, nodeTo) or
  nodeFrom = nodeTo.(PostUpdateNode).getPreUpdateNode()
}

/**
 * Gets a callable for the call where `nodeFrom` is used as the `i`'th argument.
 *
 * Helper predicate to avoid bad join order experienced in `callStep`.
 * This happened when `isParameterOf` was joined _before_ `getCallable`.
 */
pragma[nomagic]
private DataFlowCallable getCallableForArgument(ArgumentNode nodeFrom, int i) {
  exists(DataFlowCall call |
    nodeFrom.argumentOf(call, i) and
    result = call.getCallable()
  )
}

/** Holds if `nodeFrom` steps to `nodeTo` by being passed as a parameter in a call. */
predicate callStep(ArgumentNode nodeFrom, ParameterNode nodeTo) {
  // TODO: Support special methods?
  exists(DataFlowCallable callable, int i |
    callable = getCallableForArgument(nodeFrom, i) and
    nodeTo.isParameterOf(callable, i)
  )
}

/** Holds if `nodeFrom` steps to `nodeTo` by being returned from a call. */
predicate returnStep(ReturnNode nodeFrom, Node nodeTo) {
  exists(DataFlowCall call |
    nodeFrom.getEnclosingCallable() = call.getCallable() and nodeTo.asCfgNode() = call.getNode()
  )
}

/**
 * Holds if `nodeFrom` is being written to the `attr` attribute of the object in `nodeTo`.
 *
 * Note that the choice of `nodeTo` does not have to make sense "chronologically".
 * All we care about is whether the `attr` attribute of `nodeTo` can have a specific type,
 * and the assumption is that if a specific type appears here, then any access of that
 * particular attribute can yield something of that particular type.
 *
 * Thus, in an example such as
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
 * for the attribute write `x.attr = y`, we will have `attr` being the literal string `"attr"`,
 * `nodeFrom` will be `y`, and `nodeTo` will be the object `Foo()` created on the first line of the
 * function. This means we will track the fact that `x.attr` can have the type of `y` into the
 * assignment to `z` inside `bar`, even though this attribute write happens _after_ `bar` is called.
 */
predicate basicStoreStep(Node nodeFrom, Node nodeTo, string attr) {
  exists(AttrWrite a |
    a.mayHaveAttributeName(attr) and
    nodeFrom = a.getValue() and
    simpleLocalFlowStep*(nodeTo, a.getObject())
  )
}

/**
 * Holds if `nodeTo` is the result of accessing the `attr` attribute of `nodeFrom`.
 */
predicate basicLoadStep(Node nodeFrom, Node nodeTo, string attr) {
  exists(AttrRead a |
    a.mayHaveAttributeName(attr) and
    nodeFrom = a.getObject() and
    nodeTo = a
  )
}

/**
 * A utility class that is equivalent to `boolean` but does not require type joining.
 */
private class Boolean extends boolean {
  Boolean() { this = true or this = false }
}

private newtype TTypeTracker = MkTypeTracker(Boolean hasCall, OptionalAttributeName attr)

/**
 * Summary of the steps needed to track a value to a given dataflow node.
 *
 * This can be used to track objects that implement a certain API in order to
 * recognize calls to that API. Note that type-tracking does not by itself provide a
 * source/sink relation, that is, it may determine that a node has a given type,
 * but it won't determine where that type came from.
 *
 * It is recommended that all uses of this type are written in the following form,
 * for tracking some type `myType`:
 * ```
 * DataFlow::Node myType(DataFlow::TypeTracker t) {
 *   t.start() and
 *   result = < source of myType >
 *   or
 *   exists (DataFlow::TypeTracker t2 |
 *     result = myType(t2).track(t2, t)
 *   )
 * }
 *
 * DataFlow::Node myType() { result = myType(DataFlow::TypeTracker::end()) }
 * ```
 *
 * Instead of `result = myType(t2).track(t2, t)`, you can also use the equivalent
 * `t = t2.step(myType(t2), result)`. If you additionally want to track individual
 * intra-procedural steps, use `t = t2.smallstep(myCallback(t2), result)`.
 */
class TypeTracker extends TTypeTracker {
  Boolean hasCall;
  OptionalAttributeName attr;

  TypeTracker() { this = MkTypeTracker(hasCall, attr) }

  /** Gets the summary resulting from appending `step` to this type-tracking summary. */
  cached
  TypeTracker append(StepSummary step) {
    step = LevelStep() and result = this
    or
    step = CallStep() and result = MkTypeTracker(true, attr)
    or
    step = ReturnStep() and hasCall = false and result = this
    or
    step = LoadStep(attr) and result = MkTypeTracker(hasCall, "")
    or
    exists(string p | step = StoreStep(p) and attr = "" and result = MkTypeTracker(hasCall, p))
  }

  /** Gets a textual representation of this summary. */
  string toString() {
    exists(string withCall, string withAttr |
      (if hasCall = true then withCall = "with" else withCall = "without") and
      (if attr != "" then withAttr = " with attribute " + attr else withAttr = "") and
      result = "type tracker " + withCall + " call steps" + withAttr
    )
  }

  /**
   * Holds if this is the starting point of type tracking.
   */
  predicate start() { hasCall = false and attr = "" }

  /**
   * Holds if this is the starting point of type tracking, and the value starts in the attribute named `attrName`.
   * The type tracking only ends after the attribute has been loaded.
   */
  predicate startInAttr(AttributeName attrName) { hasCall = false and attr = attrName }

  /**
   * Holds if this is the starting point of type tracking
   * when tracking a parameter into a call, but not out of it.
   */
  predicate call() { hasCall = true and attr = "" }

  /**
   * Holds if this is the end point of type tracking.
   */
  predicate end() { attr = "" }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Holds if this type has been tracked into a call.
   */
  boolean hasCall() { result = hasCall }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Gets the attribute associated with this type tracker.
   */
  string getAttr() { result = attr }

  /**
   * Gets a type tracker that starts where this one has left off to allow continued
   * tracking.
   *
   * This predicate is only defined if the type has not been tracked into an attribute.
   */
  TypeTracker continue() { attr = "" and result = this }

  /**
   * Gets the summary that corresponds to having taken a forwards
   * heap and/or inter-procedural step from `nodeFrom` to `nodeTo`.
   */
  pragma[inline]
  TypeTracker step(Node nodeFrom, Node nodeTo) {
    exists(StepSummary summary |
      StepSummary::step(nodeFrom, nodeTo, summary) and
      result = this.append(summary)
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
    exists(StepSummary summary |
      StepSummary::smallstep(nodeFrom, nodeTo, summary) and
      result = this.append(summary)
    )
    or
    typePreservingStep(nodeFrom, nodeTo) and
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
