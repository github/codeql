/**
 * Simple constant analysis using the Semantic interface.
 */

private import semmle.code.java.semantic.SemanticExpr
private import semmle.code.java.semantic.SemanticSSA
private import ConstantAnalysisSpecific as Specific

/** An expression that always has the same integer value. */
pragma[nomagic]
private predicate constantIntegerExpr(SemExpr e, int val) {
  // An integer literal
  e.(SemIntegerLiteralExpr).getIntValue() = val
  or
  // Copy of another constant
  exists(SemSsaExplicitUpdate v, SemExpr src |
    e = v.getAUse() and
    src = v.getDefiningExpr().(SemVariableAssign).getSource() and
    constantIntegerExpr(src, val)
  )
  or
  // Language-specific enhancements
  val = Specific::getIntConstantValue(e)
}

/** An expression that always has the same integer value. */
class SemConstantIntegerExpr extends SemExpr {
  SemConstantIntegerExpr() { constantIntegerExpr(this, _) }

  /** Gets the integer value of this expression. */
  int getIntValue() { constantIntegerExpr(this, result) }
}
