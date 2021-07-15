private import codeql_ruby.AST as AST
private import codeql_ruby.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private import codeql_ruby.dataflow.internal.DataFlowPublic as DataFlowPublic
private import codeql_ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import codeql_ruby.dataflow.internal.DataFlowDispatch as DataFlowDispatch
private import codeql_ruby.dataflow.internal.SsaImpl as SsaImpl
private import codeql_ruby.controlflow.CfgNodes

class Node = DataFlowPublic::Node;

class TypeTrackingNode = DataFlowPublic::LocalSourceNode;

predicate simpleLocalFlowStep = DataFlowPrivate::simpleLocalFlowStep/2;

predicate jumpStep = DataFlowPrivate::jumpStep/2;

/**
 * Gets the name of a possible piece of content. This will usually include things like
 *
 * - Attribute names (in Python)
 * - Property names (in JavaScript)
 */
string getPossibleContentName() { result = getSetterCallAttributeName(_) }

/** Holds if `nodeFrom` steps to `nodeTo` by being passed as a parameter in a call. */
predicate callStep(DataFlowPrivate::ArgumentNode nodeFrom, DataFlowPublic::ParameterNode nodeTo) {
  exists(DataFlowDispatch::DataFlowCall call, DataFlowDispatch::DataFlowCallable callable, int i |
    call.getTarget() = callable and
    nodeFrom.argumentOf(call, i) and
    nodeTo.isParameterOf(callable, i)
  )
}

/** Holds if `nodeFrom` steps to `nodeTo` by being returned from a call. */
predicate returnStep(DataFlowPrivate::ReturnNode nodeFrom, Node nodeTo) {
  exists(DataFlowDispatch::DataFlowCall call |
    DataFlowImplCommon::getNodeEnclosingCallable(nodeFrom) = call.getTarget() and
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
predicate basicStoreStep(Node nodeFrom, DataFlowPublic::LocalSourceNode nodeTo, string content) {
  // TODO: support SetterMethodCall inside TuplePattern
  exists(ExprNodes::MethodCallCfgNode call |
    content = getSetterCallAttributeName(call.getExpr()) and
    nodeTo.(DataFlowPublic::ExprNode).getExprNode() = call.getReceiver() and
    call.getExpr() instanceof AST::SetterMethodCall and
    call.getArgument(call.getNumberOfArguments() - 1) =
      nodeFrom.(DataFlowPublic::ExprNode).getExprNode()
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
  exists(ExprNodes::MethodCallCfgNode call |
    call.getExpr().getNumberOfArguments() = 0 and
    content = call.getExpr().(AST::MethodCall).getMethodName() and
    nodeFrom.asExpr() = call.getReceiver() and
    nodeTo.asExpr() = call
  )
}

/**
 * A utility class that is equivalent to `boolean` but does not require type joining.
 */
class Boolean extends boolean {
  Boolean() { this = true or this = false }
}
