/**
 * Provides Python-specific definitions for use in the type tracker library.
 */

private import python
private import semmle.python.dataflow.new.internal.DataFlowPublic as DataFlowPublic
private import TypeTrackingImpl as TypeTrackingImpl

deprecated class Node = DataFlowPublic::Node;

deprecated class TypeTrackingNode = DataFlowPublic::TypeTrackingNode;

/** A content name for use by type trackers, or the empty string. */
deprecated class OptionalTypeTrackerContent extends string {
  OptionalTypeTrackerContent() {
    this = ""
    or
    this instanceof TypeTrackingImpl::TypeTrackingInput::Content
  }
}

/** A content name for use by type trackers. */
deprecated class TypeTrackerContent extends OptionalTypeTrackerContent {
  TypeTrackerContent() { this != "" }
}

/** Gets the content string representing no value. */
deprecated OptionalTypeTrackerContent noContent() { result = "" }

/**
 * A label to use for `WithContent` and `WithoutContent` steps, restricting
 * which `ContentSet` may pass through. Not currently used in Python.
 */
deprecated class ContentFilter extends Unit {
  TypeTrackerContent getAMatchingContent() { none() }
}

pragma[inline]
deprecated predicate compatibleContents(
  TypeTrackerContent storeContent, TypeTrackerContent loadContent
) {
  storeContent = loadContent
}

deprecated predicate simpleLocalFlowStep =
  TypeTrackingImpl::TypeTrackingInput::simpleLocalSmallStep/2;

deprecated predicate jumpStep = TypeTrackingImpl::TypeTrackingInput::jumpStep/2;

/** Holds if there is a level step from `nodeFrom` to `nodeTo`, which may depend on the call graph. */
deprecated predicate levelStepCall(Node nodeFrom, Node nodeTo) { none() }

/** Holds if there is a level step from `nodeFrom` to `nodeTo`, which does not depend on the call graph. */
deprecated predicate levelStepNoCall = TypeTrackingImpl::TypeTrackingInput::levelStepNoCall/2;

/**
 * Holds if `nodeFrom` steps to `nodeTo` by being passed as a parameter in a call.
 *
 * Flow into summarized library methods is not included, as that will lead to negative
 * recursion (or, at best, terrible performance), since identifying calls to library
 * methods is done using API graphs (which uses type tracking).
 */
deprecated predicate callStep = TypeTrackingImpl::TypeTrackingInput::callStep/2;

/** Holds if `nodeFrom` steps to `nodeTo` by being returned from a call. */
deprecated predicate returnStep = TypeTrackingImpl::TypeTrackingInput::returnStep/2;

/**
 * Holds if `nodeFrom` is being written to the `content` content of the object in `nodeTo`.
 */
deprecated predicate basicStoreStep = TypeTrackingImpl::TypeTrackingInput::storeStep/3;

/**
 * Holds if `nodeTo` is the result of accessing the `content` content of `nodeFrom`.
 */
deprecated predicate basicLoadStep = TypeTrackingImpl::TypeTrackingInput::loadStep/3;

/**
 * Holds if the `loadContent` of `nodeFrom` is stored in the `storeContent` of `nodeTo`.
 */
deprecated predicate basicLoadStoreStep = TypeTrackingImpl::TypeTrackingInput::loadStoreStep/4;

/**
 * Holds if type-tracking should step from `nodeFrom` to `nodeTo` but block flow of contents matched by `filter` through here.
 */
deprecated predicate basicWithoutContentStep(Node nodeFrom, Node nodeTo, ContentFilter filter) {
  none()
}

/**
 * Holds if type-tracking should step from `nodeFrom` to `nodeTo` if inside a content matched by `filter`.
 */
deprecated predicate basicWithContentStep(Node nodeFrom, Node nodeTo, ContentFilter filter) {
  none()
}

/**
 * A utility class that is equivalent to `boolean` but does not require type joining.
 */
deprecated class Boolean extends boolean {
  Boolean() { this = true or this = false }
}
