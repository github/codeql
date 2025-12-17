/**
 * @name Trait Usage
 * @description Detects and tracks trait usage in classes
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.ClassResolver

/**
 * A trait use statement in a class.
 */
class TraitUseStatement extends TS::PHP::UseDeclaration {
  /** Gets a trait name being used */
  string getATraitName() {
    result = this.getChild(_).(TS::PHP::Name).getValue() or
    result = this.getChild(_).(TS::PHP::QualifiedName).toString()
  }
}

/**
 * Gets traits directly used by a class.
 */
PhpTraitDecl getDirectUsedTrait(PhpClassDecl c) {
  exists(TraitUseStatement use, string traitName |
    use.getParent+() = c and
    traitName = use.getATraitName() and
    result.getTraitName() = traitName
  )
}

/**
 * Checks if a class directly uses a trait.
 */
predicate classDirectlyUsesTrait(PhpClassDecl c, PhpTraitDecl t) {
  getDirectUsedTrait(c) = t
}

/**
 * Gets the number of traits directly used by a class.
 */
int getDirectTraitCount(PhpClassDecl c) {
  result = count(PhpTraitDecl t | classDirectlyUsesTrait(c, t))
}

/**
 * Checks if a class uses multiple traits.
 */
predicate usesMultipleTraits(PhpClassDecl c) {
  getDirectTraitCount(c) > 1
}

/**
 * Gets a method from a trait.
 */
TS::PHP::MethodDeclaration getTraitMethod(PhpTraitDecl t) {
  result = t.getAMethod()
}

/**
 * Checks if two traits used by the same class have methods with the same name.
 */
predicate hasTraitMethodConflict(PhpClassDecl c) {
  exists(PhpTraitDecl t1, PhpTraitDecl t2, string methodName |
    classDirectlyUsesTrait(c, t1) and
    classDirectlyUsesTrait(c, t2) and
    t1 != t2 and
    t1.getAMethod().(TS::PHP::MethodDeclaration).getName().(TS::PHP::Name).getValue() = methodName and
    t2.getAMethod().(TS::PHP::MethodDeclaration).getName().(TS::PHP::Name).getValue() = methodName
  )
}

/**
 * Gets all classes that use a specific trait.
 */
PhpClassDecl getClassUsingTrait(PhpTraitDecl t) {
  classDirectlyUsesTrait(result, t)
}

/**
 * Gets the usage count for a trait.
 */
int getTraitUsageCount(PhpTraitDecl t) {
  result = count(PhpClassDecl c | classDirectlyUsesTrait(c, t))
}
