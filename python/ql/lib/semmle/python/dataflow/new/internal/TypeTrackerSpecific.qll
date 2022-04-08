/**
 * Provides Python-specific definitions for use in the type tracker library.
 */

private import python
private import semmle.python.dataflow.new.internal.DataFlowPublic as DataFlowPublic
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
import semmle.python.internal.CachedStages

class Node = DataFlowPublic::Node;

class TypeTrackingNode = DataFlowPublic::TypeTrackingNode;

predicate simpleLocalFlowStep = DataFlowPrivate::simpleLocalFlowStep/2;

predicate jumpStep = DataFlowPrivate::jumpStepSharedWithTypeTracker/2;

/** Holds if there is a level step from `pred` to `succ`. */
predicate levelStep(Node pred, Node succ) { none() }

/**
 * Gets the name of a possible piece of content. For Python, this is currently only attribute names,
 * using the name of the attribute for the corresponding content.
 */
string getPossibleContentName() {
  Stages::TypeTracking::ref() and // the TypeTracking::append() etc. predicates that we want to cache depend on this predicate, so we can place the `ref()` call here to get around identical files.
  result = any(DataFlowPublic::AttrRef a).getAttributeName()
}

/**
 * Gets a callable for the call where `nodeFrom` is used as the `i`'th argument.
 *
 * Helper predicate to avoid bad join order experienced in `callStep`.
 * This happened when `isParameterOf` was joined _before_ `getCallable`.
 */
pragma[nomagic]
private DataFlowPrivate::DataFlowCallable getCallableForArgument(
  DataFlowPublic::ArgumentNode nodeFrom, int i
) {
  exists(DataFlowPrivate::DataFlowCall call |
    nodeFrom.argumentOf(call, i) and
    result = call.getCallable()
  )
}

/** Holds if `nodeFrom` steps to `nodeTo` by being passed as a parameter in a call. */
predicate callStep(DataFlowPublic::ArgumentNode nodeFrom, DataFlowPublic::ParameterNode nodeTo) {
  // TODO: Support special methods?
  exists(DataFlowPrivate::DataFlowCallable callable, int i |
    callable = getCallableForArgument(nodeFrom, i) and
    nodeTo.isParameterOf(callable, i)
  )
}

/** Holds if `nodeFrom` steps to `nodeTo` by being returned from a call. */
predicate returnStep(DataFlowPrivate::ReturnNode nodeFrom, Node nodeTo) {
  exists(DataFlowPrivate::DataFlowCall call |
    nodeFrom.getEnclosingCallable() = call.getCallable() and nodeTo.asCfgNode() = call.getNode()
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
 * A utility class that is equivalent to `boolean` but does not require type joining.
 */
class Boolean extends boolean {
  Boolean() { this = true or this = false }
}
