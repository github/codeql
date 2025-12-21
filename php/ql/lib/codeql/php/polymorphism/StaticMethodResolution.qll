/**
 * @name Static Method Resolution
 * @description Handles static method calls and late static binding
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.MethodResolver
private import codeql.php.polymorphism.ClassResolver

/**
 * A self:: reference in code.
 */
class SelfReference extends TS::PHP::Name {
  SelfReference() {
    this.getValue() = "self"
  }
}

/**
 * A parent:: reference in code.
 */
class ParentReference extends TS::PHP::Name {
  ParentReference() {
    this.getValue() = "parent"
  }
}

/**
 * A static:: reference in code (late static binding).
 */
class StaticReference extends TS::PHP::Name {
  StaticReference() {
    this.getValue() = "static"
  }
}

/**
 * Checks if a static method call uses self::.
 */
predicate isSelfCall(StaticMethodCallExpr call) {
  call.getScopeName() = "self"
}

/**
 * Checks if a static method call uses parent::.
 */
predicate isParentCall(StaticMethodCallExpr call) {
  call.getScopeName() = "parent"
}

/**
 * Checks if a static method call uses static:: (late static binding).
 */
predicate isLateStaticBindingCall(StaticMethodCallExpr call) {
  call.getScopeName() = "static"
}

/**
 * Checks if a static method call is a direct class reference.
 */
predicate isDirectClassCall(StaticMethodCallExpr call) {
  not isSelfCall(call) and
  not isParentCall(call) and
  not isLateStaticBindingCall(call)
}
