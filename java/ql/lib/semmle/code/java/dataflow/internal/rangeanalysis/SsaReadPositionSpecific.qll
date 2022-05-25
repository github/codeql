/**
 * Provides Java-specific definitions for use in the `SsaReadPosition`.
 */

private import semmle.code.java.dataflow.SSA as Ssa
private import semmle.code.java.controlflow.BasicBlocks as BB
private import SsaReadPositionCommon

class SsaVariable = Ssa::SsaVariable;

class SsaPhiNode = Ssa::SsaPhiNode;

class BasicBlock = BB::BasicBlock;

/** Gets a basic block in which SSA variable `v` is read. */
BasicBlock getAReadBasicBlock(SsaVariable v) { result = v.getAUse().getBasicBlock() }

private predicate id(BasicBlock x, BasicBlock y) { x = y }

private predicate idOf(BasicBlock x, int y) = equivalenceRelation(id/2)(x, y)

private int getId(BasicBlock bb) { idOf(bb, result) }

/**
 * Declarations to be exposed to users of SsaReadPositionCommon
 */
module Public {
  /**
   * Holds if `inp` is an input to `phi` along `edge` and this input has index `r`
   * in an arbitrary 1-based numbering of the input edges to `phi`.
   */
  predicate rankedPhiInput(SsaPhiNode phi, SsaVariable inp, SsaReadPositionPhiInputEdge edge, int r) {
    edge.phiInput(phi, inp) and
    edge =
      rank[r](SsaReadPositionPhiInputEdge e |
        e.phiInput(phi, _)
      |
        e order by getId(e.getOrigBlock())
      )
  }
}
