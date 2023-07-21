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

/**
 * Holds if `guard` directly controls the position `controlled` with the
 * value `testIsTrue`.
 */
predicate semGuardDirectlyControlsSsaRead(
  SemGuard guard, SemSsaReadPosition controlled, boolean testIsTrue
) {
  guard.directlyControls(controlled.(SemSsaReadPositionBlock).getBlock(), testIsTrue)
  or
  exists(SemSsaReadPositionPhiInputEdge controlledEdge | controlledEdge = controlled |
    guard.directlyControls(controlledEdge.getOrigBlock(), testIsTrue) or
    guard.hasBranchEdge(controlledEdge.getOrigBlock(), controlledEdge.getPhiBlock(), testIsTrue)
  )
}

/**
 * Holds if `guard` controls the position `controlled` with the value `testIsTrue`.
 */
predicate semGuardControlsSsaRead(SemGuard guard, SemSsaReadPosition controlled, boolean testIsTrue) {
  semGuardDirectlyControlsSsaRead(guard, controlled, testIsTrue)
  or
  exists(SemGuard guard0, boolean testIsTrue0 |
    semImplies_v2(guard0, testIsTrue0, guard, testIsTrue) and
    semGuardControlsSsaRead(guard0, controlled, testIsTrue0)
  )
}

SemGuard semGetComparisonGuard(SemRelationalExpr e) { result = Specific::comparisonGuard(e) }
