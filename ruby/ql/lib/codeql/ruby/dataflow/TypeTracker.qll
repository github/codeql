/**
 * Exposes the public API for type tracking.
 *
 * See the documentation for the `TypeTracker` class for details about how to use this library.
 */

private import internal.TypeTrackerImpl as Internal
private import internal.TypeTrackerSpecific as InternalSpecific

class TypeTracker = Internal::TypeTracker;

module TypeTracker = Internal::TypeTracker;

class StepSummary = Internal::StepSummary;

module StepSummary = Internal::StepSummary;

class TypeBackTracker = Internal::TypeBackTracker;

module TypeBackTracker = Internal::TypeBackTracker;
