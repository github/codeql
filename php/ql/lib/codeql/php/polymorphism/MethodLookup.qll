/**
 * @name Method Lookup
 * @description Visibility and hierarchy-aware method lookup
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.MethodResolver

/**
 * Checks if a method is public.
 */
predicate isPublicMethod(MethodDecl method) {
  method.isPublic()
}

/**
 * Checks if a method is protected.
 */
predicate isProtectedMethod(MethodDecl method) {
  method.isProtected()
}

/**
 * Checks if a method is private.
 */
predicate isPrivateMethod(MethodDecl method) {
  method.isPrivate()
}

/**
 * Gets the visibility level of a method as a string.
 */
string getMethodVisibility(MethodDecl method) {
  isPublicMethod(method) and result = "public" or
  isProtectedMethod(method) and result = "protected" or
  isPrivateMethod(method) and result = "private"
}

/**
 * Checks if a method is static.
 */
predicate isStaticMethod(MethodDecl method) {
  method.isStatic()
}

/**
 * Checks if a method is an instance method (not static).
 */
predicate isInstanceMethod(MethodDecl method) {
  not isStaticMethod(method)
}

/**
 * Checks if method visibility is compatible in override.
 * Overriding cannot be more restrictive.
 */
predicate hasCompatibleVisibility(MethodDecl overriding, MethodDecl overridden) {
  (isPublicMethod(overridden) and isPublicMethod(overriding)) or
  (isPublicMethod(overridden) and isProtectedMethod(overriding)) or
  (isProtectedMethod(overridden) and isProtectedMethod(overriding)) or
  (isProtectedMethod(overridden) and isPublicMethod(overriding)) or
  isPrivateMethod(overridden)
}
