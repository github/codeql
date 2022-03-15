/**
 * Provides C#-specific definitions for use in the `SsaReadPosition`.
 */

private import csharp
private import SsaReadPositionCommon
private import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl as CfgImpl

class SsaVariable = Ssa::Definition;

class SsaPhiNode = Ssa::PhiNode;

class BasicBlock = ControlFlow::BasicBlock;

/** Gets a basic block in which SSA variable `v` is read. */
BasicBlock getAReadBasicBlock(SsaVariable v) {
  result = v.getARead().getAControlFlowNode().getBasicBlock()
}

private class PhiInputEdgeBlock extends BasicBlock {
  PhiInputEdgeBlock() { this = any(SsaReadPositionPhiInputEdge edge).getOrigBlock() }
}

private int getId(PhiInputEdgeBlock bb) {
  exists(CfgImpl::ControlFlowTree::Range_ t | CfgImpl::ControlFlowTree::idOf(t, result) |
    t = bb.getFirstNode().getElement()
    or
    t = bb.(ControlFlow::BasicBlocks::EntryBlock).getCallable()
  )
}

private string getSplitString(PhiInputEdgeBlock bb) {
  result = bb.getFirstNode().(ControlFlow::Nodes::ElementNode).getSplitsString()
  or
  not exists(bb.getFirstNode().(ControlFlow::Nodes::ElementNode).getSplitsString()) and
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
