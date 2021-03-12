private import python
private import semmle.python.dataflow.new.internal.DataFlowPublic as DataFlowPublic
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate

class Node = DataFlowPublic::Node;

class LocalSourceNode = DataFlowPublic::LocalSourceNode;

predicate jumpStep = DataFlowPrivate::jumpStep/2;

predicate simpleLocalFlowStep = DataFlowPrivate::simpleLocalFlowStep/2;

/**
 * Gets the name of a possible piece of content. This will usually include things like
 *
 * - Attribute names (in Python)
 * - Property names (in JavaScript)
 */
string getPossibleContentName() { result = any(DataFlowPublic::AttrRef a).getAttributeName() }

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
 *
 * Note that the choice of `nodeTo` does not have to make sense "chronologically".
 * All we care about is whether the `content` content of `nodeTo` can have a specific type,
 * and the assumption is that if a specific type appears here, then any access of that
 * particular content can yield something of that particular type.
 *
 * Thus, in an example such as
 *
 * ```python
 * def foo(y):
 *    x = Foo()
 *    bar(x)
 *    x.content = y
 *    baz(x)
 *
 * def bar(x):
 *    z = x.content
 * ```
 * for the content write `x.content = y`, we will have `content` being the literal string `"content"`,
 * `nodeFrom` will be `y`, and `nodeTo` will be the object `Foo()` created on the first line of the
 * function. This means we will track the fact that `x.content` can have the type of `y` into the
 * assignment to `z` inside `bar`, even though this content write happens _after_ `bar` is called.
 */
predicate basicStoreStep(Node nodeFrom, LocalSourceNode nodeTo, string content) {
  exists(DataFlowPublic::AttrWrite a |
    a.mayHaveAttributeName(content) and
    nodeFrom = a.getValue() and
    nodeTo.flowsTo(a.getObject())
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
