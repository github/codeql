/**
 * Provides the `TypeTracker` class for tracking types interprocedurally.
 *
 * This provides an alternative to `DataFlow::TrackedNode` and `AbstractValue`
 * for tracking certain types interprocedurally without computing which source
 * a given value came from.
 */

import javascript
private import internal.FlowSteps

/**
 * A description of a step on an inter-procedural data flow path.
 */
private newtype TStepSummary =
  LevelStep() or
  CallStep() or
  ReturnStep()

/**
 * INTERNAL: Use `TypeTracker` or `TypeBackTracker` instead.
 *
 * A description of a step on an inter-procedural data flow path.
 */
class StepSummary extends TStepSummary {
  /** Indicates whether the step represented by this summary is a return. */
  boolean hasReturn() { if this instanceof ReturnStep then result = true else result = false }

  /** Indicates whether the step represented by this summary is a call. */
  boolean hasCall() { if this instanceof CallStep then result = true else result = false }

  /** Gets a textual representation of this step summary. */
  string toString() {
    this instanceof LevelStep and result = "level"
    or
    this instanceof CallStep and result = "call"
    or
    this instanceof ReturnStep and result = "return"
  }
}

module StepSummary {
  /**
   * INTERNAL: Use `SourceNode.track()` or `SourceNode.backtrack()` instead.
   */
  predicate step(DataFlow::SourceNode pred, DataFlow::SourceNode succ, StepSummary summary) {
    exists(DataFlow::Node predNode | pred.flowsTo(predNode) |
      // Flow through properties of objects
      propertyFlowStep(predNode, succ) and
      summary = LevelStep()
      or
      // Flow through global variables
      globalFlowStep(predNode, succ) and
      summary = LevelStep()
      or
      // Flow into function
      callStep(predNode, succ) and
      summary = CallStep()
      or
      // Flow out of function
      returnStep(predNode, succ) and
      summary = ReturnStep()
      or
      // Flow through an instance field between members of the same class
      DataFlow::localFieldStep(predNode, succ) and
      summary = LevelStep()
    )
  }

  /**
   * INTERNAL. Do not use.
   *
   * Appends a step summary onto a type-tracking summary.
   */
  TypeTracker append(TypeTracker type, StepSummary summary) {
    not (type.hasCall() = true and summary.hasReturn() = true) and
    result.hasCall() = type.hasCall().booleanOr(summary.hasCall())
  }

  /**
   * INTERNAL. Do not use.
   *
   * Prepends a step summary before a backwards type-tracking summary.
   */
  TypeBackTracker prepend(StepSummary summary, TypeBackTracker type) {
    not (type.hasReturn() = true and summary.hasCall() = true) and
    result.hasReturn() = type.hasReturn().booleanOr(summary.hasReturn())
  }
}

private newtype TTypeTracker = MkTypeTracker(Boolean hasCall)

/**
 * EXPERIMENTAL.
 *
 * Summary of the steps needed to track a value to a given dataflow node.
 *
 * This can be used to track objects that implement a certain API in order to
 * recognize calls to that API. Note that type-tracking does not provide a
 * source/sink relation, that is, it may determine that a node has a given type,
 * but it won't determine where that type came from.
 *
 * It is recommended that all uses of this type is written on the following form,
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
 * DataFlow::SourceNode myType() { result = myType(_) }
 * ```
 *
 * To track values backwards, which can be useful for tracking
 * the type of a callback, use the `TypeBackTracker` class instead.
 */
class TypeTracker extends TTypeTracker {
  Boolean hasCall;

  TypeTracker() { this = MkTypeTracker(hasCall) }

  string toString() {
    hasCall = true and result = "type tracker with call steps"
    or
    hasCall = false and result = "type tracker without call steps"
  }

  /**
   * Holds if this is the starting point of type tracking.
   */
  predicate start() { hasCall = false }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Holds if this type has been tracked into a call.
   */
  boolean hasCall() { result = hasCall }
}

private newtype TTypeBackTracker = MkTypeBackTracker(Boolean hasReturn)

/**
 * EXPERIMENTAL.
 *
 * Summary of the steps needed to back-track a use of a value to a given dataflow node.
 *
 * This can be used to track callbacks that are passed to a certian API call, and are
 * therefore expected to called with a certain type of value.
 *
 * Note that type back-tracking does not provide a source/sink relation, that is,
 * it may determine that a node will be used in an API call somwwhere, but it won't
 * determine exactly where that use was, or the path that led to the use.
 *
 * It is recommended that all uses of this type is written on the following form,
 * for back-tracking some callback type `myCallback`:
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
 * DataFlow::SourceNode myCallback() { result = myCallback(_) }
 * ```
 */
class TypeBackTracker extends TTypeBackTracker {
  Boolean hasReturn;

  TypeBackTracker() { this = MkTypeBackTracker(hasReturn) }

  string toString() {
    hasReturn = true and result = "type back-tracker with return steps"
    or
    hasReturn = false and result = "type back-tracker without return steps"
  }

  /**
   * Holds if this is the starting point of type tracking.
   */
  predicate start() { hasReturn = false }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Holds if this type has been back-tracked into a call through return edge.
   */
  boolean hasReturn() { result = hasReturn }
}
