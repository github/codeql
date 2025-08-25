/**
 * Provides a class for the Swift nil-coalesing expr (`??`)
 */

private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.expr.BinaryExpr

/**
 * A Swift nil-coalesing expr (`??`).
 */
final class NilCoalescingExpr extends BinaryExpr {
  NilCoalescingExpr() { this.getStaticTarget().getName() = "??(_:_:)" }
}
