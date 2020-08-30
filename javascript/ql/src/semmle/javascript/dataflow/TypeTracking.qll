/**
 * Provides the `TypeTracker` class for tracking types interprocedurally.
 *
 * This provides an alternative to `AbstractValue`
 * for tracking certain types interprocedurally without computing which source
 * a given value came from.
 */

private import javascript
private import internal.FlowSteps
private import internal.StepSummary

private newtype TTypeTracker = MkTypeTracker(Boolean hasCall, OptionalPropertyName prop)

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
 * DataFlow::SourceNode myType(DataFlow::TypeTracker t) {
 *   t.start() and
 *   result = < source of myType >
 *   or
 *   exists (DataFlow::TypeTracker t2 |
 *     result = myType(t2).track(t2, t)
 *   )
 * }
 *
 * DataFlow::SourceNode myType() { result = myType(DataFlow::TypeTracker::end()) }
 * ```
 *
 * Instead of `result = myType(t2).track(t2, t)`, you can also use the equivalent
 * `t = t2.step(myType(t2), result)`. If you additionally want to track individual
 * intra-procedural steps, use `t = t2.smallstep(myCallback(t2), result)`.
 *
 * To track values backwards, which can be useful for tracking the type of a callback,
 * use the `TypeBackTracker` class instead.
 */
class TypeTracker extends TTypeTracker {
  Boolean hasCall;
  OptionalPropertyName prop;

  TypeTracker() { this = MkTypeTracker(hasCall, prop) }

  /** Gets the summary resulting from appending `step` to this type-tracking summary. */
  cached
  TypeTracker append(StepSummary step) {
    step = LevelStep() and result = this
    or
    exists(string toProp | step = LoadStoreStep(prop, toProp) |
      result = MkTypeTracker(hasCall, toProp)
    )
    or
    step = CopyStep(prop) and result = this
    or
    step = CallStep() and result = MkTypeTracker(true, prop)
    or
    step = ReturnStep() and hasCall = false and result = this
    or
    step = LoadStep(prop) and result = MkTypeTracker(hasCall, "")
    or
    exists(string p | step = StoreStep(p) and prop = "" and result = MkTypeTracker(hasCall, p))
  }

  /** Gets a textual representation of this summary. */
  string toString() {
    exists(string withCall, string withProp |
      (if hasCall = true then withCall = "with" else withCall = "without") and
      (if prop != "" then withProp = " with property " + prop else withProp = "") and
      result = "type tracker " + withCall + " call steps" + withProp
    )
  }

  /**
   * Holds if this is the starting point of type tracking.
   */
  predicate start() { hasCall = false and prop = "" }

  /**
   * Holds if this is the starting point of type tracking, and the value starts in the property named `propName`.
   * The type tracking only ends after the property has been loaded.
   */
  predicate startInProp(PropertyName propName) { hasCall = false and prop = propName }

  /**
   * Holds if this is the starting point of type tracking, and the initial value is a promise.
   * The type tracking only ends after the value has been extracted from the promise.
   */
  predicate startInPromise() { startInProp(Promises::valueProp()) }

  /**
   * Holds if this is the starting point of type tracking
   * when tracking a parameter into a call, but not out of it.
   */
  predicate call() { hasCall = true and prop = "" }

  /**
   * Holds if this is the end point of type tracking.
   */
  predicate end() { prop = "" }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Holds if this type has been tracked into a call.
   */
  boolean hasCall() { result = hasCall }

  /**
   * Gets a type tracker that starts where this one has left off to allow continued
   * tracking.
   *
   * This predicate is only defined if the type has not been tracked into a property.
   */
  TypeTracker continue() { prop = "" and result = this }

  /**
   * Gets the summary that corresponds to having taken a forwards
   * heap and/or inter-procedural step from `pred` to `succ`.
   */
  pragma[inline]
  TypeTracker step(DataFlow::SourceNode pred, DataFlow::SourceNode succ) {
    exists(StepSummary summary |
      StepSummary::step(pred, succ, summary) and
      result = this.append(summary)
    )
  }

  /**
   * Gets the summary that corresponds to having taken a forwards
   * local, heap and/or inter-procedural step from `pred` to `succ`.
   *
   * Unlike `TypeTracker::step`, this predicate exposes all edges
   * in the flow graph, and not just the edges between `SourceNode`s.
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
  TypeTracker smallstep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StepSummary summary |
      StepSummary::smallstep(pred, succ, summary) and
      result = this.append(summary)
    )
    or
    succ = pred.getASuccessor() and
    result = this
  }
}

module TypeTracker {
  /**
   * Gets a valid end point of type tracking.
   */
  TypeTracker end() { result.end() }
}

private newtype TTypeBackTracker = MkTypeBackTracker(Boolean hasReturn, OptionalPropertyName prop)

/**
 * Summary of the steps needed to back-track a use of a value to a given dataflow node.
 *
 * This can be used to track callbacks that are passed to a certian API call, and are
 * therefore expected to called with a certain type of value.
 *
 * Note that type back-tracking does not provide a source/sink relation, that is,
 * it may determine that a node will be used in an API call somewhere, but it won't
 * determine exactly where that use was, or the path that led to the use.
 *
 * It is recommended that all uses of this type are written in the following form,
 * for back-tracking some callback type `myCallback`:
 *
 * ```
 * DataFlow::SourceNode myCallback(DataFlow::TypeBackTracker t) {
 *   t.start() and
 *   result = (< some API call >).getArgument(< n >).getALocalSource()
 *   or
 *   exists (DataFlow::TypeBackTracker t2 |
 *     result = myCallback(t2).backtrack(t2, t)
 *   )
 * }
 *
 * DataFlow::SourceNode myCallback() { result = myCallback(DataFlow::TypeBackTracker::end()) }
 * ```
 *
 * Instead of `result = myCallback(t2).backtrack(t2, t)`, you can also use the equivalent
 * `t2 = t.step(result, myCallback(t2))`. If you additionally want to track individual
 * intra-procedural steps, use `t2 = t.smallstep(result, myCallback(t2))`.
 */
class TypeBackTracker extends TTypeBackTracker {
  Boolean hasReturn;
  string prop;

  TypeBackTracker() { this = MkTypeBackTracker(hasReturn, prop) }

  /** Gets the summary resulting from prepending `step` to this type-tracking summary. */
  TypeBackTracker prepend(StepSummary step) {
    step = LevelStep() and result = this
    or
    exists(string fromProp | step = LoadStoreStep(fromProp, prop) |
      result = MkTypeBackTracker(hasReturn, fromProp)
    )
    or
    step = CopyStep(prop) and result = this
    or
    step = CallStep() and hasReturn = false and result = this
    or
    step = ReturnStep() and result = MkTypeBackTracker(true, prop)
    or
    exists(string p | step = LoadStep(p) and prop = "" and result = MkTypeBackTracker(hasReturn, p))
    or
    step = StoreStep(prop) and result = MkTypeBackTracker(hasReturn, "")
  }

  /** Gets a textual representation of this summary. */
  string toString() {
    exists(string withReturn, string withProp |
      (if hasReturn = true then withReturn = "with" else withReturn = "without") and
      (if prop != "" then withProp = " with property " + prop else withProp = "") and
      result = "type back-tracker " + withReturn + " return steps" + withProp
    )
  }

  /**
   * Holds if this is the starting point of type tracking.
   */
  predicate start() { hasReturn = false and prop = "" }

  /**
   * Holds if this is the end point of type tracking.
   */
  predicate end() { prop = "" }

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
   * This predicate is only defined if the type has not been tracked into a property.
   */
  TypeBackTracker continue() { prop = "" and result = this }

  /**
   * Gets the summary that corresponds to having taken a backwards
   * heap and/or inter-procedural step from `succ` to `pred`.
   */
  pragma[inline]
  TypeBackTracker step(DataFlow::SourceNode pred, DataFlow::SourceNode succ) {
    exists(StepSummary summary |
      StepSummary::step(pred, succ, summary) and
      this = result.prepend(summary)
    )
  }

  /**
   * Gets the summary that corresponds to having taken a backwards
   * local, heap and/or inter-procedural step from `succ` to `pred`.
   *
   * Unlike `TypeBackTracker::step`, this predicate exposes all edges
   * in the flowgraph, and not just the edges between
   * `SourceNode`s. It may therefore be less performant.
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
  TypeBackTracker smallstep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StepSummary summary |
      StepSummary::smallstep(pred, succ, summary) and
      this = result.prepend(summary)
    )
    or
    pred = succ.getAPredecessor() and
    this = result
  }
}

module TypeBackTracker {
  /**
   * Gets a valid end point of type back-tracking.
   */
  TypeBackTracker end() { result.end() }
}

/**
 * A data flow edge that should be followed by type tracking.
 *
 * Unlike `AdditionalFlowStep`, this type of edge does not affect
 * the local data flow graph, and is not used by data-flow configurations.
 *
 * Note: For performance reasons, all subclasses of this class should be part
 * of the standard library. For query-specific steps, consider including the
 * custom steps in the type-tracking predicate itself.
 */
abstract class AdditionalTypeTrackingStep extends DataFlow::Node {
  /**
   * Holds if type-tracking should step from `pred` to `succ`.
   */
  predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if type-tracking should step from `pred` into the `prop` property of `succ`.
   */
  predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) { none() }

  /**
   * Holds if type-tracking should step from the `prop` property of `pred` to `succ`.
   */
  predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) { none() }

  /**
   * Holds if type-tracking should step from the `prop` property of `pred` to the same property in `succ`.
   */
  predicate loadStoreStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) { none() }
}
