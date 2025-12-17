/**
 * @name Type System Integration
 * @description Integration between polymorphism and type system
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.ClassResolver

/**
 * A type-aware class declaration.
 */
class TypedClassDecl extends PhpClassDecl {
  /** Gets the number of typed properties */
  int getTypedPropertyCount() {
    result = count(TS::PHP::PropertyDeclaration p |
      p.getParent+() = this and exists(p.getType())
    )
  }

  /** Gets the number of typed methods */
  int getTypedMethodCount() {
    result = count(TS::PHP::MethodDeclaration m |
      m.getParent+() = this and exists(m.getReturnType())
    )
  }
}

/**
 * Checks if type is compatible in polymorphic context.
 */
bindingset[actual, expected]
predicate isTypeCompatibleInPolymorphism(string actual, string expected) {
  actual = expected or expected = "mixed" or expected = "object"
}
