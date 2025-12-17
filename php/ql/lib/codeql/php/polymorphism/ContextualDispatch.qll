/**
 * @name Contextual Dispatch
 * @description Context-aware method dispatch analysis
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.ClassResolver
private import codeql.php.polymorphism.MethodResolver

/**
 * A method call in a specific context.
 */
class ContextualMethodCall extends TS::PHP::MemberCallExpression {
  /** Gets the enclosing function */
  TS::PHP::FunctionDefinition getEnclosingFunction() {
    result = this.getParent+()
  }

  /** Gets the enclosing class */
  PhpClassDecl getEnclosingClass() {
    result = this.getParent+()
  }
}

/**
 * Checks if a method call is in a constructor context.
 */
predicate isInConstructorContext(ContextualMethodCall call) {
  exists(TS::PHP::MethodDeclaration m |
    m = call.getParent+() and
    m.getName().(TS::PHP::Name).getValue() = "__construct"
  )
}

/**
 * Checks if a method call is in a static context.
 */
predicate isInStaticContext(ContextualMethodCall call) {
  exists(TS::PHP::MethodDeclaration m |
    m = call.getParent+() and
    exists(TS::PHP::StaticModifier s | s = m.getChild(_))
  )
}

/**
 * Checks if dispatch is conditional (depends on a condition).
 */
predicate isConditionalDispatch(TS::PHP::MemberCallExpression call) {
  exists(TS::PHP::IfStatement if_ | call.getParent+() = if_)
}

/**
 * Checks if dispatch is in a loop context.
 */
predicate isLoopDispatch(TS::PHP::MemberCallExpression call) {
  exists(TS::PHP::ForStatement f | call.getParent+() = f) or
  exists(TS::PHP::ForeachStatement f | call.getParent+() = f) or
  exists(TS::PHP::WhileStatement f | call.getParent+() = f)
}
