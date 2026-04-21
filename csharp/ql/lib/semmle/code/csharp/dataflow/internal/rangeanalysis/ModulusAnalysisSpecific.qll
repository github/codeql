module Private {
  private import csharp as CS
  private import ConstantUtils as CU
  private import semmle.code.csharp.dataflow.internal.rangeanalysis.RangeUtils as RU
  private import SsaUtils as SU
  private import SsaReadPositionCommon
  private import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl as CfgImpl

  class BasicBlock = CS::ControlFlow::BasicBlock;

  class SsaVariable = SU::SsaVariable;

  class SsaPhiNode = CS::Ssa::PhiNode;

  class Expr = CS::ControlFlow::Nodes::ExprNode;

  class Guard = RU::Guard;

  class ConstantIntegerExpr = CU::ConstantIntegerExpr;

  class ConditionalExpr = RU::ExprNode::ConditionalExpr;

  class AddExpr = RU::ExprNode::AddOperation;

  class SubExpr = RU::ExprNode::SubOperation;

  class RemExpr = RU::ExprNode::RemOperation;

  class BitwiseAndExpr = RU::ExprNode::BitwiseAndOperation;

  class MulExpr = RU::ExprNode::MulOperation;

  class LeftShiftExpr = RU::ExprNode::LeftShiftOperation;

  predicate guardControlsSsaRead = RU::guardControlsSsaRead/3;

  predicate valueFlowStep = RU::valueFlowStep/3;

  predicate eqFlowCond = RU::eqFlowCond/5;

  predicate ssaUpdateStep = RU::ssaUpdateStep/3;

  Expr getABasicBlockExpr(BasicBlock bb) { result = bb.getANode() }
}
