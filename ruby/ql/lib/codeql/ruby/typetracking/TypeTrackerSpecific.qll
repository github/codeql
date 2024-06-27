private import codeql.ruby.dataflow.internal.DataFlowPublic as DataFlowPublic
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import internal.TypeTrackingImpl as TypeTrackingImpl
deprecated import codeql.util.Boolean

deprecated class Node = DataFlowPublic::Node;

deprecated class TypeTrackingNode = DataFlowPublic::LocalSourceNode;

deprecated class TypeTrackerContent = DataFlowPublic::ContentSet;

/**
 * An optional content set, that is, a `ContentSet` or the special "no content set" value.
 */
deprecated class OptionalTypeTrackerContent extends DataFlowPrivate::TOptionalContentSet {
  /** Gets a textual representation of this content set. */
  string toString() {
    this instanceof DataFlowPrivate::TNoContentSet and
    result = "no content"
    or
    result = this.(DataFlowPublic::ContentSet).toString()
  }
}

/**
 * A label to use for `WithContent` and `WithoutContent` steps, restricting
 * which `ContentSet` may pass through.
 */
deprecated class ContentFilter = TypeTrackingImpl::TypeTrackingInput::ContentFilter;

/** Module for getting `ContentFilter` values. */
deprecated module ContentFilter {
  /** Gets the filter that only allow element contents. */
  ContentFilter hasElements() { any() }
}

/**
 * Holds if a value stored with `storeContents` can be read back with `loadContents`.
 */
pragma[inline]
deprecated predicate compatibleContents(
  TypeTrackerContent storeContents, TypeTrackerContent loadContents
) {
  storeContents.getAStoreContent() = loadContents.getAReadContent()
}

/** Gets the "no content set" value to use for a type tracker not inside any content. */
deprecated OptionalTypeTrackerContent noContent() { result = DataFlowPrivate::TNoContentSet() }

/** Holds if there is a simple local flow step from `nodeFrom` to `nodeTo` */
deprecated predicate simpleLocalFlowStep =
  TypeTrackingImpl::TypeTrackingInput::simpleLocalSmallStep/2;

/**
 * Holds if data can flow from `node1` to `node2` in a way that discards call contexts.
 */
deprecated predicate jumpStep = TypeTrackingImpl::TypeTrackingInput::jumpStep/2;

/** Holds if there is a level step from `nodeFrom` to `nodeTo`, which may depend on the call graph. */
deprecated predicate levelStepCall = TypeTrackingImpl::TypeTrackingInput::levelStepCall/2;

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

/**
 * Holds if `nodeFrom` steps to `nodeTo` by being returned from a call.
 *
 * Flow out of summarized library methods is not included, as that will lead to negative
 * recursion (or, at best, terrible performance), since identifying calls to library
 * methods is done using API graphs (which uses type tracking).
 */
deprecated predicate returnStep = TypeTrackingImpl::TypeTrackingInput::returnStep/2;

/**
 * Holds if `nodeFrom` is being written to the `contents` of the object
 * in `nodeTo`.
 *
 * Note that the choice of `nodeTo` does not have to make sense
 * "chronologically". All we care about is whether the `contents` of
 * `nodeTo` can have a specific type, and the assumption is that if a specific
 * type appears here, then any access of that particular content can yield
 * something of that particular type.
 *
 * Thus, in an example such as
 *
 * ```rb
 * def foo(y)
 *    x = Foo.new
 *    bar(x)
 *    x.content = y
 *    baz(x)
 * end
 *
 * def bar(x)
 *    z = x.content
 * end
 * ```
 * for the content write `x.content = y`, we will have `contents` being the
 * literal string `"content"`, `nodeFrom` will be `y`, and `nodeTo` will be the
 * `Foo` object created on the first line of the function. This means we will
 * track the fact that `x.content` can have the type of `y` into the assignment
 * to `z` inside `bar`, even though this content write happens _after_ `bar` is
 * called.
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
deprecated predicate basicWithoutContentStep =
  TypeTrackingImpl::TypeTrackingInput::withoutContentStep/3;

/**
 * Holds if type-tracking should step from `nodeFrom` to `nodeTo` if inside a content matched by `filter`.
 */
deprecated predicate basicWithContentStep = TypeTrackingImpl::TypeTrackingInput::withContentStep/3;
