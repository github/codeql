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

  final predicate controls(SemBasicBlock controlled, boolean branch) {
    Specific::guardDirectlyControlsBlock(this, controlled, branch)
  }

  final predicate controlsBranchEdge(SemBasicBlock bb1, SemBasicBlock bb2, boolean branch) {
    Specific::guardHasBranchEdge(this, bb1, bb2, branch)
  }

  final SemBasicBlock getBasicBlock() { result = block }

  final SemExpr asExpr() { result = Specific::getGuardAsExpr(this) }
}

SemGuard semGetComparisonGuard(SemRelationalExpr e) { result = Specific::comparisonGuard(e) }
