/**
 * Provides classes for deref expressions (`*`).
 */

private import codeql.rust.elements.PrefixExpr
private import codeql.rust.elements.Operation

/**
 * A dereference expression, `*`.
 */
final class DerefExpr extends PrefixExpr, Operation {
  DerefExpr() { this.getOperatorName() = "*" }
}
