/**
 * Semantic wrapper around the language-specific bounds library.
 */

private import SemanticExpr
private import SemanticExprSpecific::SemanticExprConfig as Specific
private import SemanticSSA

/**
 * A valid base for an expression bound.
 *
 * Can be either a variable (`SemSsaBound`) or zero (`SemZeroBound`).
 */
class SemBound instanceof Specific::Bound {
  final string toString() { result = super.toString() }

  final SemExpr getExpr(int delta) { result = Specific::getBoundExpr(this, delta) }
}

/**
 * A bound that is a constant zero.
 */
class SemZeroBound extends SemBound {
  SemZeroBound() { Specific::zeroBound(this) }
}

/**
 * A bound that is an SSA definition.
 */
class SemSsaBound extends SemBound {
  /**
   * The variables whose value is used as the bound.
   *
   * Can be multi-valued in some implementations. If so, all variables will be equivalent.
   */
  SemSsaVariable var;

  SemSsaBound() { Specific::ssaBound(this, var) }

  /** Gets a variable whose value is used as the bound. */
  final SemSsaVariable getAVariable() { result = var }
}
