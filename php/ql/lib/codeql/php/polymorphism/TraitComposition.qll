/**
 * @name Trait Composition
 * @description Implements trait method precedence and composition rules
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.ClassResolver
private import codeql.php.polymorphism.TraitUsage

/**
 * Gets the method precedence for a method in a class.
 * 0 = direct class method, 1 = trait method, 2 = inherited method
 */
bindingset[methodName]
int getMethodPrecedence(PhpClassDecl c, string methodName) {
  exists(c.getMethodByName(methodName)) and result = 0
  or
  not exists(c.getMethodByName(methodName)) and
  exists(PhpTraitDecl t, TS::PHP::MethodDeclaration m |
    classDirectlyUsesTrait(c, t) and
    m = t.getAMethod() and
    m.getName().(TS::PHP::Name).getValue() = methodName
  ) and
  result = 1
  or
  result = 2
}

/**
 * Checks if a method is directly defined in a class.
 */
predicate isDirectClassMethod(PhpClassDecl c, string methodName) {
  exists(c.getMethodByName(methodName))
}

/**
 * Checks if a method comes from a trait.
 */
predicate isTraitProvidedMethod(PhpClassDecl c, PhpTraitDecl t, string methodName) {
  classDirectlyUsesTrait(c, t) and
  t.getAMethod().(TS::PHP::MethodDeclaration).getName().(TS::PHP::Name).getValue() = methodName
}

/**
 * Checks if a trait method is overridden by a class method.
 */
predicate traitMethodOverriddenByClass(PhpClassDecl c, PhpTraitDecl t, string methodName) {
  isTraitProvidedMethod(c, t, methodName) and
  isDirectClassMethod(c, methodName)
}

/**
 * Detects trait methods that shadow parent methods.
 */
predicate traitMethodShadowsParent(PhpClassDecl c, PhpTraitDecl t, string methodName) {
  isTraitProvidedMethod(c, t, methodName) and
  exists(PhpClassDecl parent |
    parent.getClassName() = c.getParentClassName() and
    exists(parent.getMethodByName(methodName))
  )
}
