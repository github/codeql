/**
 * This file acts as a wrapper for `internal.TypeTracker`, exposing some of the functionality with
 * names that are more appropriate for Python.
 */

private import python
private import internal.TypeTracker as Internal

/** A string that may appear as the name of an attribute or access path. */
class AttributeName = Internal::ContentName;

/** An attribute name, or the empty string (representing no attribute). */
class OptionalAttributeName = Internal::OptionalContentName;

/**
 * The summary of the steps needed to track a value to a given dataflow node.
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
 * DataFlow::LocalSourceNode myType() { myType(DataFlow::TypeTracker::end()) }
 * ```
 *
 * Instead of `result = myType(t2).track(t2, t)`, you can also use the equivalent
 * `t = t2.step(myType(t2), result)`. If you additionally want to track individual
 * intra-procedural steps, use `t = t2.smallstep(myCallback(t2), result)`.
 */
class TypeTracker extends Internal::TypeTracker {
  /**
   * Holds if this is the starting point of type tracking, and the value starts in the attribute named `attrName`.
   * The type tracking only ends after the attribute has been loaded.
   */
  predicate startInAttr(string attrName) { this.startInContent(attrName) }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Gets the attribute associated with this type tracker.
   */
  string getAttr() { result = this.getContent() }
}

module TypeTracker = Internal::TypeTracker;

class StepSummary = Internal::StepSummary;

module StepSummary = Internal::StepSummary;

class TypeBackTracker = Internal::TypeBackTracker;

module TypeBackTracker = Internal::TypeBackTracker;
