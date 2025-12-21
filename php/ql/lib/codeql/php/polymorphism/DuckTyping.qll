/**
 * @name Duck Typing
 * @description Duck typing patterns in PHP
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.ClassResolver

/**
 * A method call on an untyped variable (duck typing).
 */
class DuckTypedCall extends TS::PHP::MemberCallExpression {
  DuckTypedCall() {
    // The object is a simple variable without type hint context
    this.getObject() instanceof TS::PHP::VariableName
  }
}

/**
 * Checks if a variable is used with duck typing.
 */
predicate isDuckTypedVariable(TS::PHP::VariableName v) {
  exists(DuckTypedCall call | call.getObject() = v)
}

/**
 * Checks if a class implements methods for duck typing.
 */
predicate implementsImplicitProtocol(PhpClassDecl c, string methodName) {
  exists(c.getMethodByName(methodName))
}
