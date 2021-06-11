/**
 * This file acts as a wrapper for `internal.TypeTracker`, exposing some of the functionality with
 * names that are more appropriate for Python.
 */

private import python
private import internal.TypeTracker as Internal

/** Any string that may appear as the name of an attribute or access path. */
class AttributeName = Internal::ContentName;

/** Either an attribute name, or the empty string (representing no attribute). */
class OptionalAttributeName = Internal::OptionalContentName;

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
