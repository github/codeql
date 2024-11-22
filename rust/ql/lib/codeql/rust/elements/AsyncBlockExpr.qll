/**
 * This module provides the public class `AsyncBlockExpr`.
 */

private import codeql.rust.elements.BlockExpr

/**
 * An async block expression. For example:
 * ```rust
 * async {
 *     let x = 42;
 * }
 * ```
 */
final class AsyncBlockExpr extends BlockExpr {
  AsyncBlockExpr() { this.isAsync() }
}
