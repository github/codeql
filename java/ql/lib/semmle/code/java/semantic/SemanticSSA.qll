/**
 * Semantic interface to the SSA library.
 */

private import java
private import semmle.code.java.dataflow.SSA as SSA
private import SemanticCFG
private import SemanticExpr
private import SemanticType
private import semmle.code.java.dataflow.internal.rangeanalysis.SsaReadPositionCommon

private newtype TSemSsaVariable = MkSemSsaVariable(SSA::SsaVariable var)

class SemSsaVariable extends TSemSsaVariable {
  SSA::SsaVariable var;

  SemSsaVariable() { this = MkSemSsaVariable(var) }

  final string toString() { result = var.toString() }

  final SemExpr getAUse() { result = getSemanticExpr(var.getAUse()) }

  final SemSsaSourceVariable getSourceVariable() {
    result = getSemanticSsaSourceVariable(var.getSourceVariable())
  }

  final SemBasicBlock getBasicBlock() { result = getSemanticBasicBlock(var.getBasicBlock()) }
}

class SemSsaExplicitUpdate extends SemSsaVariable {
  override SSA::SsaExplicitUpdate var;

  final SemExpr getDefiningExpr() { result = getSemanticExpr(var.getDefiningExpr()) }
}

class SemSsaPhiNode extends SemSsaVariable {
  override SSA::SsaPhiNode var;

  final SemSsaVariable getAPhiInput() { result = getSemanticSsaVariable(var.getAPhiInput()) }
}

private newtype TSemSsaSourceVariable = MkSemSsaSourceVariable(SSA::SsaSourceVariable sourceVar)

class SemSsaSourceVariable extends TSemSsaSourceVariable {
  SSA::SsaSourceVariable sourceVar;

  SemSsaSourceVariable() { this = MkSemSsaSourceVariable(sourceVar) }

  final string toString() { result = sourceVar.toString() }

  final SemType getType() { result = getSemanticType(sourceVar.getType()) }
}

SemSsaVariable getSemanticSsaVariable(SSA::SsaVariable var) { result = MkSemSsaVariable(var) }

SSA::SsaVariable getJavaSsaVariable(SemSsaVariable var) { var = getSemanticSsaVariable(result) }

SemSsaSourceVariable getSemanticSsaSourceVariable(SSA::SsaSourceVariable var) {
  result = MkSemSsaSourceVariable(var)
}

private newtype TSemSsaReadPosition = MkSemSsaReadPosition(SsaReadPosition pos)

class SemSsaReadPosition extends TSemSsaReadPosition {
  SsaReadPosition pos;

  SemSsaReadPosition() { this = MkSemSsaReadPosition(pos) }

  final string toString() { result = pos.toString() }

  final predicate hasReadOfVar(SemSsaVariable var) { pos.hasReadOfVar(getJavaSsaVariable(var)) }
}

class SemSsaReadPositionPhiInputEdge extends SemSsaReadPosition {
  override SsaReadPositionPhiInputEdge pos;

  predicate phiInput(SemSsaPhiNode phi, SemSsaVariable inp) {
    pos.phiInput(getJavaSsaVariable(phi), getJavaSsaVariable(inp))
  }

  SemBasicBlock getOrigBlock() { result = getSemanticBasicBlock(pos.getOrigBlock()) }

  SemBasicBlock getPhiBlock() { result = getSemanticBasicBlock(pos.getPhiBlock()) }
}

class SemSsaReadPositionBlock extends SemSsaReadPosition {
  override SsaReadPositionBlock pos;

  SemBasicBlock getBlock() { result = getSemanticBasicBlock(pos.getBlock()) }

  SemExpr getAnExpr() { result = getBlock().getAnExpr() }
}

SemSsaReadPosition getSemanticSsaReadPosition(SsaReadPosition pos) {
  result = MkSemSsaReadPosition(pos)
}

/**
 * Holds if `inp` is an input to `phi` along a back edge.
 */
predicate semBackEdge(SemSsaPhiNode phi, SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge) {
  edge.phiInput(phi, inp) and
  // Conservatively assume that every edge is a back edge if we don't have dominance information.
  (
    phi.getBasicBlock().bbDominates(edge.getOrigBlock()) or
    not semHasDominanceInformation(edge.getOrigBlock())
  )
}
