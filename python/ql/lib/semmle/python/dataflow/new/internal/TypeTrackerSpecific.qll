/**
 * Provides Python-specific definitions for use in the type tracker library.
 */

private import python
private import semmle.python.dataflow.new.internal.DataFlowPublic as DataFlowPublic
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
import semmle.python.internal.CachedStages

class Node = DataFlowPublic::Node;

class TypeTrackingNode = DataFlowPublic::TypeTrackingNode;

/** A content name for use by type trackers, or the empty string. */
class OptionalTypeTrackerContent extends string {
  OptionalTypeTrackerContent() {
    this = ""
    or
    this = getPossibleContentName()
  }
}

/** A content name for use by type trackers. */
class TypeTrackerContent extends OptionalTypeTrackerContent {
  TypeTrackerContent() { this != "" }
}

/** Gets the content string representing no value. */
OptionalTypeTrackerContent noContent() { result = "" }

/**
 * A label to use for `WithContent` and `WithoutContent` steps, restricting
 * which `ContentSet` may pass through. Not currently used in Python.
 */
class ContentFilter extends Unit {
  TypeTrackerContent getAMatchingContent() { none() }
}

pragma[inline]
predicate compatibleContents(TypeTrackerContent storeContent, TypeTrackerContent loadContent) {
  storeContent = loadContent
}

predicate simpleLocalFlowStep = DataFlowPrivate::simpleLocalFlowStepForTypetracking/2;

predicate jumpStep = DataFlowPrivate::jumpStepSharedWithTypeTracker/2;

/** Holds if there is a level step from `nodeFrom` to `nodeTo`, which may depend on the call graph. */
predicate levelStepCall(Node nodeFrom, Node nodeTo) { none() }

/** Holds if there is a level step from `nodeFrom` to `nodeTo`, which does not depend on the call graph. */
predicate levelStepNoCall(Node nodeFrom, Node nodeTo) { none() }

/**
 * Gets the name of a possible piece of content. For Python, this is currently only attribute names,
 * using the name of the attribute for the corresponding content.
 */
string getPossibleContentName() {
  Stages::TypeTracking::ref() and // the TypeTracking::append() etc. predicates that we want to cache depend on this predicate, so we can place the `ref()` call here to get around identical files.
  result = any(DataFlowPublic::AttrRef a).getAttributeName()
}

/**
 * Holds if `nodeFrom` steps to `nodeTo` by being passed as a parameter in a call.
 *
 * Flow into summarized library methods is not included, as that will lead to negative
 * recursion (or, at best, terrible performance), since identifying calls to library
 * methods is done using API graphs (which uses type tracking).
 */
predicate callStep(DataFlowPublic::ArgumentNode nodeFrom, DataFlowPublic::ParameterNode nodeTo) {
  exists(
    DataFlowPrivate::DataFlowCall call, DataFlowPrivate::DataFlowCallable callable,
    DataFlowPrivate::ArgumentPosition apos, DataFlowPrivate::ParameterPosition ppos
  |
    nodeFrom = call.getArgument(apos) and
    nodeTo = callable.getParameter(ppos) and
    DataFlowPrivate::parameterMatch(ppos, apos) and
    callable = call.getCallable()
  )
}

/** Holds if `nodeFrom` steps to `nodeTo` by being returned from a call. */
predicate returnStep(DataFlowPrivate::ReturnNode nodeFrom, Node nodeTo) {
  exists(DataFlowPrivate::ExtractedDataFlowCall call |
    nodeFrom.getEnclosingCallable() = call.getCallable() and
    nodeTo.(DataFlowPublic::CfgNode).getNode() = call.getNode()
  )
}

/**
 * Holds if `nodeFrom` is being written to the `content` content of the object in `nodeTo`.
 */
predicate basicStoreStep(Node nodeFrom, Node nodeTo, string content) {
  exists(DataFlowPublic::AttrWrite a |
    a.mayHaveAttributeName(content) and
    nodeFrom = a.getValue() and
    nodeTo = a.getObject()
  )
}

/**
 * Holds if `nodeTo` is the result of accessing the `content` content of `nodeFrom`.
 */
predicate basicLoadStep(Node nodeFrom, Node nodeTo, string content) {
  exists(DataFlowPublic::AttrRead a |
    a.mayHaveAttributeName(content) and
    nodeFrom = a.getObject() and
    nodeTo = a
  )
}

/**
 * Holds if the `loadContent` of `nodeFrom` is stored in the `storeContent` of `nodeTo`.
 */
predicate basicLoadStoreStep(Node nodeFrom, Node nodeTo, string loadContent, string storeContent) {
  none()
}

/**
 * Holds if type-tracking should step from `nodeFrom` to `nodeTo` but block flow of contents matched by `filter` through here.
 */
predicate basicWithoutContentStep(Node nodeFrom, Node nodeTo, ContentFilter filter) { none() }

/**
 * Holds if type-tracking should step from `nodeFrom` to `nodeTo` if inside a content matched by `filter`.
 */
predicate basicWithContentStep(Node nodeFrom, Node nodeTo, ContentFilter filter) { none() }

/**
 * A utility class that is equivalent to `boolean` but does not require type joining.
 */
class Boolean extends boolean {
  Boolean() { this = true or this = false }
}
