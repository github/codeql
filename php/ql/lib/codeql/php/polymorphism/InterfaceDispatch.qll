/**
 * @name Interface Dispatch
 * @description Handles interface-based method dispatch
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.ClassResolver

/**
 * Gets the interfaces implemented by a class.
 */
TS::PHP::Name getImplementedInterface(PhpClassDecl c) {
  result = c.getChild(_).(TS::PHP::ClassInterfaceClause).getChild(_).(TS::PHP::Name)
}

/**
 * Checks if a class implements an interface.
 */
predicate implementsInterface(PhpClassDecl c, string interfaceName) {
  getImplementedInterface(c).getValue() = interfaceName
}

/**
 * Gets all classes implementing an interface.
 */
PhpClassDecl getImplementingClass(string interfaceName) {
  implementsInterface(result, interfaceName)
}

/**
 * Checks if a class implements all required interface methods.
 */
predicate implementsAllInterfaceMethods(PhpClassDecl c) {
  // Placeholder - would need full interface method tracking
  any()
}
