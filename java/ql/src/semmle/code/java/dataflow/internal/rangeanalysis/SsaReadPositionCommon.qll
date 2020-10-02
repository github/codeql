/**
 * Provides classes for representing a position at which an SSA variable is read.
 */

private import SsaReadPositionSpecific

private newtype TSsaReadPosition =
  TSsaReadPositionBlock(BasicBlock bb) { bb = getAReadBasicBlock(_) } or
  TSsaReadPositionPhiInputEdge(BasicBlock bbOrig, BasicBlock bbPhi) {
    exists(SsaPhiNode phi | phi.hasInputFromBlock(_, bbOrig) and bbPhi = phi.getBasicBlock())
  }

/**
 * A position at which an SSA variable is read. This includes both ordinary
 * reads occurring in basic blocks and input to phi nodes occurring along an
 * edge between two basic blocks.
 */
class SsaReadPosition extends TSsaReadPosition {
  /** Holds if `v` is read at this position. */
  abstract predicate hasReadOfVar(SsaVariable v);

  /** Gets a textual representation of this SSA read position. */
  abstract string toString();
}

/** A basic block in which an SSA variable is read. */
class SsaReadPositionBlock extends SsaReadPosition, TSsaReadPositionBlock {
  /** Gets the basic block corresponding to this position. */
  BasicBlock getBlock() { this = TSsaReadPositionBlock(result) }

  override predicate hasReadOfVar(SsaVariable v) { getBlock() = getAReadBasicBlock(v) }

  override string toString() { result = "block" }
}

/**
 * An edge between two basic blocks where the latter block has an SSA phi
 * definition. The edge therefore has a read of an SSA variable serving as the
 * input to the phi node.
 */
class SsaReadPositionPhiInputEdge extends SsaReadPosition, TSsaReadPositionPhiInputEdge {
  /** Gets the source of the edge. */
  BasicBlock getOrigBlock() { this = TSsaReadPositionPhiInputEdge(result, _) }

  /** Gets the target of the edge. */
  BasicBlock getPhiBlock() { this = TSsaReadPositionPhiInputEdge(_, result) }

  override predicate hasReadOfVar(SsaVariable v) { this.phiInput(_, v) }

  /** Holds if `inp` is an input to `phi` along this edge. */
  predicate phiInput(SsaPhiNode phi, SsaVariable inp) {
    phi.hasInputFromBlock(inp, getOrigBlock()) and
    getPhiBlock() = phi.getBasicBlock()
  }

  override string toString() { result = "edge" }
}
