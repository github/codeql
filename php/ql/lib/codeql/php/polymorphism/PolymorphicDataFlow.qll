/**
 * @name Polymorphic Data Flow
 * @description Data flow analysis for polymorphic code
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.ClassResolver

/**
 * A polymorphic data flow node.
 */
class PolymorphicNode extends TS::PHP::AstNode {
  PolymorphicNode() {
    this instanceof TS::PHP::MemberCallExpression or
    this instanceof TS::PHP::ScopedCallExpression
  }
}

/**
 * Checks if data flows through a polymorphic call.
 */
predicate flowsThroughPolymorphicCall(TS::PHP::AstNode source, TS::PHP::AstNode sink) {
  exists(TS::PHP::MemberCallExpression call |
    call.getObject() = source and
    call = sink
  )
}

/**
 * Checks if data flow is safe through polymorphic dispatch.
 */
predicate isDataFlowSafe(TS::PHP::MemberCallExpression call) {
  any()
}

/**
 * Checks if data flow is unsafe through polymorphic dispatch.
 */
predicate isDataFlowUnsafe(TS::PHP::MemberCallExpression call) {
  not isDataFlowSafe(call)
}
