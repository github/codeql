/**
 * @name PHP 8.5 NoDiscard Attribute
 * @description Provides analysis for PHP 8.5 #[NoDiscard] attribute
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

// PHP 8.5 NoDiscard attribute detection requires attribute name access
// which is not fully supported in current tree-sitter grammar
// This is a placeholder for future implementation

/**
 * Placeholder for NoDiscard attribute detection.
 * NoDiscard uses syntax like:
 * #[NoDiscard]
 * function getValue(): int { ... }
 */
predicate isNoDiscardAttribute(TS::PHP::Attribute attr) {
  // Will be implemented when attribute name access is properly supported
  none()
}

/**
 * Placeholder class for NoDiscard function detection.
 */
class NoDiscardFunction extends TS::PHP::FunctionDefinition {
  NoDiscardFunction() {
    // Will be implemented when attribute detection is supported
    none()
  }

  /** Gets the function name */
  string getFunctionName() {
    result = this.getName().(TS::PHP::Name).getValue()
  }
}

/**
 * Placeholder class for NoDiscard method detection.
 */
class NoDiscardMethod extends TS::PHP::MethodDeclaration {
  NoDiscardMethod() {
    // Will be implemented when attribute detection is supported
    none()
  }

  /** Gets the method name */
  string getMethodName() {
    result = this.getName().(TS::PHP::Name).getValue()
  }
}

/**
 * Checks if a function/method has the NoDiscard attribute.
 */
predicate hasNoDiscardAttribute(TS::PHP::AstNode decl) {
  decl instanceof NoDiscardFunction or
  decl instanceof NoDiscardMethod
}
