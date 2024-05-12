/**
 * Semantic interface to the guards library.
 */

private import Semantic
private import SemanticExprSpecific::SemanticExprConfig as Specific

class SemGuard instanceof Specific::Guard {
  SemBasicBlock block;

  SemGuard() { Specific::guard(this, block) }

  final string toString() { result = super.toString() }

  final Specific::Location getLocation() { result = super.getLocation() }

  final predicate isEquality(SemExpr e1, SemExpr e2, boolean polarity) {
    Specific::equalityGuard(this, e1, e2, polarity)
  }

  final predicate directlyControls(SemBasicBlock controlled, boolean branch) {
    Specific::guardDirectlyControlsBlock(this, controlled, branch)
  }

  final predicate hasBranchEdge(SemBasicBlock bb1, SemBasicBlock bb2, boolean branch) {
    Specific::guardHasBranchEdge(this, bb1, bb2, branch)
  }

  final SemBasicBlock getBasicBlock() { result = block }

  final SemExpr asExpr() { result = Specific::getGuardAsExpr(this) }
}

predicate semImplies_v2(SemGuard g1, boolean b1, SemGuard g2, boolean b2) {
  Specific::implies_v2(g1, b1, g2, b2)
}

SemGuard semGetComparisonGuard(SemRelationalExpr e) { result = Specific::comparisonGuard(e) }
