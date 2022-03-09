/**
 * Semantic wrapper around the shared bounds library.
 */

private import SemanticExpr
private import SemanticExprSpecific::SemanticExprConfig as Specific
private import SemanticSSA

class SemBound instanceof Specific::Bound {
  final string toString() { result = super.toString() }

  final SemExpr getExpr(int delta) { result = Specific::getBoundExpr(this, delta) }
}

class SemZeroBound extends SemBound {
  SemZeroBound() { Specific::zeroBound(this) }
}

class SemSsaBound extends SemBound {
  SemSsaVariable var;

  SemSsaBound() { Specific::ssaBound(this, var) }

  final SemSsaVariable getSsa() { result = var }
}
