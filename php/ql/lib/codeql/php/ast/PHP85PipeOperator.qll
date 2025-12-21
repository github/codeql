/**
 * @name PHP 8.5+ Pipe Operator
 * @description Analysis for pipe operator (|>)
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

// PHP 8.5 pipe operator is not yet in tree-sitter grammar
// This is a placeholder for future implementation

/**
 * Placeholder for pipe operator detection.
 * Pipe operator uses syntax like:
 * $value |> trim(...) |> strtolower(...)
 */
predicate isPipeExpression(TS::PHP::AstNode n) {
  // Will be implemented when tree-sitter supports PHP 8.5 pipe operator
  none()
}
