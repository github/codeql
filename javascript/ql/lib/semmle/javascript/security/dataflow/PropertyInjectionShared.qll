/**
 * Provides predicates for reasoning about flow of user-controlled values that are used
 * as property names.
 */

import javascript

module PropertyInjection {
  /**
   * Holds if the methods of the given value are unsafe, such as `eval`.
   */
  predicate hasUnsafeMethods(DataFlow::SourceNode node) {
    // eval and friends can be accessed from the global object.
    node = DataFlow::globalObjectRef()
    or
    // document.write can be accessed
    node = DOM::documentRef()
    or
    // 'constructor' property leads to the Function constructor.
    node.analyze().getAValue() instanceof AbstractCallable
    or
    // Assume that a value that is invoked can refer to a function.
    exists(node.getAnInvocation())
  }

  /**
   * Holds if the `node` is of form `Object.create(null)` and so it has no prototype.
   */
  predicate isPrototypeLessObject(DataFlow::MethodCallNode node) {
    node = DataFlow::globalVarRef("Object").getAMethodCall("create") and
    node.getArgument(0).asExpr() instanceof NullLiteral
  }
}
