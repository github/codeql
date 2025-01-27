/**
 * Provides Python-specific definitions for use in the type tracker library.
 */

private import python
private import semmle.python.dataflow.new.internal.DataFlowPublic as DataFlowPublic
private import TypeTrackingImpl as TypeTrackingImpl

deprecated predicate simpleLocalFlowStep =
  TypeTrackingImpl::TypeTrackingInput::simpleLocalSmallStep/2;

deprecated predicate jumpStep = TypeTrackingImpl::TypeTrackingInput::jumpStep/2;

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
