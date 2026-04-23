/**
 * Provides C#-specific definitions for use in the `SsaReadPosition`.
 */

private import csharp as CS
private import SsaReadPositionCommon

class SsaVariable = CS::Ssa::Definition;

class SsaPhiNode = CS::Ssa::PhiNode;

class BasicBlock = CS::BasicBlock;

/** Gets a basic block in which SSA variable `v` is read. */
BasicBlock getAReadBasicBlock(SsaVariable v) { result = v.getARead().getBasicBlock() }

private class PhiInputEdgeBlock extends BasicBlock {
  PhiInputEdgeBlock() { this = any(SsaReadPositionPhiInputEdge edge).getOrigBlock() }
}

private predicate id(CS::ControlFlowElementOrCallable x, CS::ControlFlowElementOrCallable y) {
  x = y
}

private predicate idOfAst(CS::ControlFlowElementOrCallable x, int y) =
  equivalenceRelation(id/2)(x, y)

private predicate idOf(PhiInputEdgeBlock x, int y) { idOfAst(x.getFirstNode().getAstNode(), y) }

private int getId1(PhiInputEdgeBlock bb) { idOf(bb, result) }

private string getId2(PhiInputEdgeBlock bb) { bb.getFirstNode().getIdTag() = result }

/**
 * Declarations to be exposed to users of SsaReadPositionCommon.
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
        e order by getId1(e.getOrigBlock()), getId2(e.getOrigBlock())
      )
  }
}
