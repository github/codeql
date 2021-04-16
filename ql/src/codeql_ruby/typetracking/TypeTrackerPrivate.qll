private import codeql_ruby.AST as AST
private import codeql_ruby.dataflow.internal.DataFlowPublic as DataFlowPublic
private import codeql_ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import codeql_ruby.dataflow.internal.DataFlowDispatch as DataFlowDispatch

class Node = DataFlowPublic::Node;

class LocalSourceNode = DataFlowPublic::LocalSourceNode;

/** Holds if it's reasonable to expect the data flow step from `nodeFrom` to `nodeTo` to preserve types. */
predicate typePreservingStep(Node nodeFrom, Node nodeTo) {
  DataFlowPrivate::simpleLocalFlowStep(nodeFrom, nodeTo) or
  DataFlowPrivate::jumpStep(nodeFrom, nodeTo)
}

/**
 * Gets the name of a possible piece of content. This will usually include things like
 *
 * - Attribute names (in Python)
 * - Property names (in JavaScript)
 */
string getPossibleContentName() { result = getSetterCallAttributeName(_) }

/** Holds if `nodeFrom` steps to `nodeTo` by being passed as a parameter in a call. */
predicate callStep(
  DataFlowPrivate::ArgumentNode nodeFrom, DataFlowPrivate::ExplicitParameterNode nodeTo
) {
  exists(DataFlowDispatch::DataFlowCall call, DataFlowDispatch::DataFlowCallable callable, int i |
    call.getCallable() = callable and
    nodeFrom.argumentOf(call, i) and
    nodeTo.isParameterOf(callable, i)
  )
}

/** Holds if `nodeFrom` steps to `nodeTo` by being returned from a call. */
predicate returnStep(DataFlowPrivate::ReturnNode nodeFrom, Node nodeTo) {
  exists(DataFlowDispatch::DataFlowCall call |
    nodeFrom.getEnclosingCallable() = call.getCallable() and
    nodeTo.asExpr().getNode() = call.getNode()
  )
}

/**
 * Holds if `nodeFrom` is being written to the `content` content of the object
 * in `nodeTo`.
 *
 * Note that the choice of `nodeTo` does not have to make sense
 * "chronologically". All we care about is whether the `content` content of
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
 * for the content write `x.content = y`, we will have `content` being the
 * literal string `"content"`, `nodeFrom` will be `y`, and `nodeTo` will be the
 * `Foo` object created on the first line of the function. This means we will
 * track the fact that `x.content` can have the type of `y` into the assignment
 * to `z` inside `bar`, even though this content write happens _after_ `bar` is
 * called.
 */
predicate basicStoreStep(Node nodeFrom, LocalSourceNode nodeTo, string content) {
  // TODO: support SetterMethodCall inside TuplePattern
  exists(AST::Assignment assignment, AST::SetterMethodCall call, DataFlowPublic::ExprNode receiver |
    assignment.getLeftOperand() = call and
    content = getSetterCallAttributeName(call) and
    receiver.getExprNode().getNode() = call.getReceiver() and
    assignment.getRightOperand() = nodeFrom.(DataFlowPublic::ExprNode).getExprNode().getNode() and
    nodeTo.flowsTo(receiver)
  )
}

/**
 * Returns the name of the attribute being set by the setter method call, i.e.
 * the name of the setter method without the trailing `=`. In the following
 * example, the result is `"bar"`.
 *
 * ```rb
 * foo.bar = 1
 * ```
 */
private string getSetterCallAttributeName(AST::SetterMethodCall call) {
  // TODO: this should be exposed in `SetterMethodCall`
  not call instanceof AST::ElementReference and
  exists(string setterName |
    setterName = call.getMethodName() and result = setterName.prefix(setterName.length() - 1)
  )
}

/**
 * Holds if `nodeTo` is the result of accessing the `content` content of `nodeFrom`.
 */
predicate basicLoadStep(Node nodeFrom, Node nodeTo, string content) {
  exists(AST::MethodCall call |
    call.getNumberOfArguments() = 0 and
    content = call.getMethodName() and
    nodeFrom.asExpr().getNode() = call.getReceiver() and
    nodeTo.asExpr().getNode() = call
  )
}

/**
 * A utility class that is equivalent to `boolean` but does not require type joining.
 */
class Boolean extends boolean {
  Boolean() { this = true or this = false }
}
