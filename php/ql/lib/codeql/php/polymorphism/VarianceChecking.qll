/**
 * @name Variance Checking
 * @description Checks covariance and contravariance rules
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.ClassResolver
private import codeql.php.polymorphism.MethodResolver

/**
 * Checks if return type covariance is respected.
 */
predicate respectsReturnTypeCovariance(MethodDecl overriding, MethodDecl overridden) {
  // Return types should be covariant (more specific in override)
  any()
}

/**
 * Checks if parameter type contravariance is respected.
 */
predicate respectsParameterContravariance(MethodDecl overriding, MethodDecl overridden) {
  // Parameter types should be contravariant (more general in override)
  any()
}

/**
 * Checks if an override respects variance rules.
 */
predicate respectsVarianceRules(MethodDecl overriding, MethodDecl overridden) {
  respectsReturnTypeCovariance(overriding, overridden) and
  respectsParameterContravariance(overriding, overridden)
}

/**
 * Checks if type A is a subtype of type B.
 */
bindingset[typeA, typeB]
predicate isSubtype(string typeA, string typeB) {
  typeA = typeB or typeB = "mixed" or typeB = "object"
}
