/**
 * Semantic interface to the SSA library.
 */

private import Semantic
private import SemanticExprSpecific::SemanticExprConfig as Specific

class SemSsaVariable instanceof Specific::SsaVariable {
  final string toString() { result = super.toString() }

  final Specific::Location getLocation() { result = super.getLocation() }

  final SemLoadExpr getAUse() { result = Specific::getAUse(this) }

  final SemType getType() { result = Specific::getSsaVariableType(this) }

  final SemBasicBlock getBasicBlock() { result = Specific::getSsaVariableBasicBlock(this) }
}

class SemSsaExplicitUpdate extends SemSsaVariable {
  SemExpr sourceExpr;

  SemSsaExplicitUpdate() { Specific::explicitUpdate(this, sourceExpr) }

  final SemExpr getSourceExpr() { result = sourceExpr }
}

class SemSsaPhiNode extends SemSsaVariable {
  SemSsaPhiNode() { Specific::phi(this) }

  final SemSsaVariable getAPhiInput() { result = Specific::getAPhiInput(this) }
}

class SemSsaReadPosition instanceof Specific::SsaReadPosition {
  final string toString() { result = super.toString() }

  final Specific::Location getLocation() { result = super.getLocation() }

  final predicate hasReadOfVar(SemSsaVariable var) { Specific::hasReadOfSsaVariable(this, var) }
}

class SemSsaReadPositionPhiInputEdge extends SemSsaReadPosition {
  SemBasicBlock origBlock;
  SemBasicBlock phiBlock;

  SemSsaReadPositionPhiInputEdge() { Specific::phiInputEdge(this, origBlock, phiBlock) }

  predicate phiInput(SemSsaPhiNode phi, SemSsaVariable inp) { Specific::phiInput(this, phi, inp) }

  SemBasicBlock getOrigBlock() { result = origBlock }

  SemBasicBlock getPhiBlock() { result = phiBlock }
}

class SemSsaReadPositionBlock extends SemSsaReadPosition {
  SemBasicBlock block;

  SemSsaReadPositionBlock() { Specific::readBlock(this, block) }

  SemBasicBlock getBlock() { result = block }

  SemExpr getAnExpr() { result = getBlock().getAnExpr() }
}

/**
 * Holds if `inp` is an input to `phi` along a back edge.
 */
predicate semBackEdge(SemSsaPhiNode phi, SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge) {
  edge.phiInput(phi, inp) and
  // Conservatively assume that every edge is a back edge if we don't have dominance information.
  (
    phi.getBasicBlock().bbDominates(edge.getOrigBlock()) or
    not edge.getOrigBlock().hasDominanceInformation()
  )
}
