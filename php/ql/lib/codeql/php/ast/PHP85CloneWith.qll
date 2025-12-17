/**
 * @name PHP 8.5+ Clone With
 * @description Analysis for clone with expression
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

// PHP 8.5 clone with is not yet in tree-sitter grammar
// This is a placeholder for future implementation

/**
 * Placeholder for clone with expression detection.
 * Clone with uses syntax like:
 * $copy = clone $obj with { $prop = $value };
 */
predicate isCloneWithExpression(TS::PHP::AstNode n) {
  // Will be implemented when tree-sitter supports PHP 8.5 clone with
  none()
}
