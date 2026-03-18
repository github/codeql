/**
 * Provides C#-specific definitions for use in the `SsaReadPosition`.
 */

private import csharp as CS
private import SsaReadPositionCommon
private import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl as CfgImpl

class SsaVariable = CS::Ssa::Definition;

class SsaPhiNode = CS::Ssa::PhiNode;

class BasicBlock = CS::BasicBlock;

/** Gets a basic block in which SSA variable `v` is read. */
BasicBlock getAReadBasicBlock(SsaVariable v) {
  result = v.getARead().getAControlFlowNode().getBasicBlock()
}

private class PhiInputEdgeBlock extends BasicBlock {
  PhiInputEdgeBlock() { this = any(SsaReadPositionPhiInputEdge edge).getOrigBlock() }
}

private int getId(PhiInputEdgeBlock bb) {
  exists(CfgImpl::AstNode n | result = n.getId() |
    n = bb.getFirstNode().getAstNode()
    or
    n = bb.(CS::ControlFlow::BasicBlocks::EntryBlock).getEnclosingCallable()
  )
}

private string getSplitString(PhiInputEdgeBlock bb) {
  result = bb.getFirstNode().(CS::ControlFlowNodes::ElementNode).getSplitsString()
  or
  not exists(bb.getFirstNode().(CS::ControlFlowNodes::ElementNode).getSplitsString()) and
  result = ""
}

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
        e order by getId(e.getOrigBlock()), getSplitString(e.getOrigBlock())
      )
  }
}
