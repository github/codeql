/**
 * Semantic interface to the guards library.
 */

private import java
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.controlflow.internal.GuardsLogic
private import SemanticCFG
private import SemanticCFGSpecific
private import SemanticExpr
private import SemanticExprSpecific
private import SemanticSSA

class LanguageGuard = Guard;

private newtype TSemGuard = MkSemGuard(LanguageGuard guard)

class SemGuard extends TSemGuard {
  LanguageGuard guard;

  SemGuard() { this = MkSemGuard(guard) }

  final string toString() { result = guard.toString() }

  final predicate isEquality(SemExpr e1, SemExpr e2, boolean polarity) {
    guard.isEquality(getJavaExpr(e1), getJavaExpr(e2), polarity)
  }

  final predicate directlyControls(SemBasicBlock controlled, boolean branch) {
    guard.directlyControls(getJavaBasicBlock(controlled), branch)
  }

  final predicate hasBranchEdge(SemBasicBlock bb1, SemBasicBlock bb2, boolean branch) {
    guard.hasBranchEdge(getJavaBasicBlock(bb1), getJavaBasicBlock(bb2), branch)
  }

  final SemBasicBlock getBasicBlock() { result = getSemanticBasicBlock(guard.getBasicBlock()) }

  final SemExpr asExpr() { result = getSemanticExpr(guard) }
}

predicate semImplies_v2(SemGuard g1, boolean b1, SemGuard g2, boolean b2) {
  implies_v2(getLanguageGuard(g1), b1, getLanguageGuard(g2), b2)
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

SemGuard semGetComparisonGuard(SemRelationalExpr e) { result = getSemanticGuard(getJavaExpr(e)) }

SemGuard getSemanticGuard(LanguageGuard guard) { result = MkSemGuard(guard) }

LanguageGuard getLanguageGuard(SemGuard guard) { guard = getSemanticGuard(result) }
