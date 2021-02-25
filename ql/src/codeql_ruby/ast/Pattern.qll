private import codeql_ruby.AST
private import codeql.Locations
private import internal.Pattern
private import internal.Variable

/** A pattern. */
class Pattern extends AstNode {
  override Pattern::Range range;

  Pattern() { range = this }

  /** Gets a variable used in (or introduced by) this pattern. */
  Variable getAVariable() { result = range.getAVariable() }
}

/**
 * A "left-hand-side" expression. An `LhsExpr` can occur on the left-hand side of
 * operator assignments (`AssignOperation`), in patterns (`Pattern`) on the left-hand side of
 * an assignment (`AssignExpr`) or for loop (`ForExpr`), and as the exception
 * variable of a `rescue` clause (`RescueClause`).
 *
 * An `LhsExpr` can be a simple variable, a constant, a call, or an element reference:
 * ```rb
 * var = 1
 * var += 1
 * E = 1
 * foo.bar = 1
 * foo[0] = 1
 * rescue E => var
 * ```
 */
class LhsExpr extends Pattern, Expr {
  override LhsExpr::Range range;
}

/** A simple variable pattern. */
class VariablePattern extends Pattern, VariablePattern::VariableToken {
  override VariablePattern::Range range;

  /** Gets the variable used in (or introduced by) this pattern. */
  Variable getVariable() { access(this, result) }
}

/**
 * A tuple pattern.
 *
 * This includes both tuple patterns in parameters and assignments. Example patterns:
 * ```rb
 * a, self.b = value
 * (a, b), c[3] = value
 * a, b, *rest, c, d = value
 * ```
 */
class TuplePattern extends Pattern {
  override TuplePattern::Range range;

  /** Gets the `i`th pattern in this tuple pattern. */
  final Pattern getElement(int i) { result = range.getElement(i) }

  /** Gets a sub pattern in this tuple pattern. */
  final Pattern getAnElement() { result = this.getElement(_) }

  /**
   * Gets the index of the pattern with the `*` marker on it, if it exists.
   * In the example below the index is `2`.
   * ```rb
   * a, b, *rest, c, d = value
   * ```
   */
  final int getRestIndex() { result = range.getRestIndex() }
}
