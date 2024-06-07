/**
 * Semantic interface to the SSA library.
 */

private import Semantic
private import SemanticExprSpecific::SemanticExprConfig as Specific

class SemSsaVariable instanceof Specific::SsaVariable {
  final string toString() { result = super.toString() }

  final Specific::Location getLocation() { result = super.getLocation() }

  final SemExpr getAUse() { result = Specific::getAUse(this) }

  final SemType getType() { result = Specific::getSsaVariableType(this) }

  final SemBasicBlock getBasicBlock() { result = Specific::getSsaVariableBasicBlock(this) }
}

class SemSsaExplicitUpdate extends SemSsaVariable {
  SemExpr sourceExpr;

  SemSsaExplicitUpdate() { Specific::explicitUpdate(this, sourceExpr) }

  final SemExpr getDefiningExpr() { result = sourceExpr }
}

class SemSsaPhiNode extends SemSsaVariable {
  SemSsaPhiNode() { Specific::phi(this) }

  final SemSsaVariable getAPhiInput() { result = Specific::getAPhiInput(this) }

  final predicate hasInputFromBlock(SemSsaVariable inp, SemBasicBlock bb) {
    Specific::phiInputFromBlock(this, inp, bb)
  }
}
