/** Provides commonly used dataflow sanitizers */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow

/**
 * A sanitizer for flow into a string interpolation component,
 * provided that component does not form a prefix of the string.
 *
 * This is useful for URLs and paths, where the fixed prefix prevents the user from controlling the target.
 */
class PrefixedStringInterpolation extends DataFlow::Node {
  PrefixedStringInterpolation() {
    exists(StringlikeLiteral str, int n | str.getComponent(n) = this.asExpr().getExpr() and n > 0)
  }
}
