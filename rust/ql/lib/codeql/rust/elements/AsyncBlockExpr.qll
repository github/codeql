private import codeql.rust.elements.BlockExpr

/**
 * A async block expression. For example:
 * ```rust
 * async {
 *     let x = 42;
 * }
 * ```
 */
final class AsyncBlockExpr extends BlockExpr {
  AsyncBlockExpr() { this.isAsync() }
}
