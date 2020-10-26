module Private {
  private import csharp as CS
  private import ConstantUtils as CU
  private import semmle.code.csharp.dataflow.internal.rangeanalysis.RangeUtils as RU
  private import SsaUtils as SU
  private import SsaReadPositionCommon

  class BasicBlock = CS::Ssa::BasicBlock;

  class SsaVariable = SU::SsaVariable;

  class SsaPhiNode = CS::Ssa::PhiNode;

  class Expr = CS::ControlFlow::Nodes::ExprNode;

  class Guard = RU::Guard;

  class ConstantIntegerExpr = CU::ConstantIntegerExpr;

  class ConditionalExpr = RU::ExprNode::ConditionalExpr;

  class AddExpr = RU::ExprNode::AddExpr;

  class SubExpr = RU::ExprNode::SubExpr;

  class RemExpr = RU::ExprNode::RemExpr;

  class BitwiseAndExpr = RU::ExprNode::BitwiseAndExpr;

  class MulExpr = RU::ExprNode::MulExpr;

  class LShiftExpr = RU::ExprNode::LShiftExpr;

  predicate guardDirectlyControlsSsaRead = RU::guardControlsSsaRead/3;

  predicate guardControlsSsaRead = RU::guardControlsSsaRead/3;

  predicate valueFlowStep = RU::valueFlowStep/3;

  predicate eqFlowCond = RU::eqFlowCond/5;

  predicate ssaUpdateStep = RU::ssaUpdateStep/3;

  Expr getABasicBlockExpr(BasicBlock bb) { result = bb.getANode() }

  private class CallableOrCFE extends CS::Element {
    CallableOrCFE() { this instanceof CS::Callable or this instanceof CS::ControlFlowElement }
  }

  private predicate id(CallableOrCFE x, CallableOrCFE y) { x = y }

  private predicate idOf(CallableOrCFE x, int y) = equivalenceRelation(id/2)(x, y)

  private class PhiInputEdgeBlock extends BasicBlock {
    PhiInputEdgeBlock() { this = any(SsaReadPositionPhiInputEdge edge).getOrigBlock() }
  }

  int getId(PhiInputEdgeBlock bb) {
    idOf(bb.getFirstNode().getElement(), result)
    or
    idOf(bb.(CS::ControlFlow::BasicBlocks::EntryBlock).getCallable(), result)
  }

  private string getSplitString(PhiInputEdgeBlock bb) {
    result = bb.getFirstNode().(CS::ControlFlow::Nodes::ElementNode).getSplitsString()
    or
    not exists(bb.getFirstNode().(CS::ControlFlow::Nodes::ElementNode).getSplitsString()) and
    result = ""
  }

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
