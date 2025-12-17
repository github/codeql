/**
 * @name PHP 8.4+ Asymmetric Visibility
 * @description Analysis for asymmetric property visibility
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

// PHP 8.4 asymmetric visibility is not yet in tree-sitter grammar
// This is a placeholder for future implementation

/**
 * Placeholder for asymmetric visibility detection.
 * Asymmetric visibility uses syntax like:
 * public private(set) string $name;
 */
predicate hasAsymmetricVisibility(TS::PHP::PropertyDeclaration p) {
  // Will be implemented when tree-sitter supports PHP 8.4 asymmetric visibility
  none()
}
