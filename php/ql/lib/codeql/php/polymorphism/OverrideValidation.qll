/**
 * @name Override Validation
 * @description Validates method overrides
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.ClassResolver
private import codeql.php.polymorphism.MethodResolver

/**
 * Checks if a method override has a compatible signature.
 */
predicate hasCompatibleOverrideSignature(MethodDecl overriding, MethodDecl overridden) {
  overriding.getParameterCount() >= overridden.getParameterCount()
}

/**
 * Detects method override issues.
 */
predicate hasOverrideIssue(PhpClassDecl c, MethodDecl m) {
  exists(PhpClassDecl parent, MethodDecl parentMethod |
    parent.getClassName() = c.getParentClassName() and
    parentMethod = parent.getAMethod() and
    parentMethod.(MethodDecl).getMethodName() = m.getMethodName() and
    not hasCompatibleOverrideSignature(m, parentMethod)
  )
}

/**
 * Checks if a method is final and cannot be overridden.
 */
predicate isFinalMethod(MethodDecl m) {
  m.isFinal()
}

/**
 * Checks if an abstract method is properly implemented.
 */
predicate implementsAbstractMethod(PhpClassDecl c, string methodName) {
  exists(c.getMethodByName(methodName))
}
