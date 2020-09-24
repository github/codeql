module Private {
  private import semmle.code.java.dataflow.SSA as Ssa
  private import java as J
  private import semmle.code.java.dataflow.RangeUtils as RU
  private import semmle.code.java.controlflow.Guards as G
  private import semmle.code.java.controlflow.BasicBlocks as BB

  class BasicBlock = BB::BasicBlock;

  class SsaVariable = Ssa::SsaVariable;

  class SsaPhiNode = Ssa::SsaPhiNode;

  class Expr = J::Expr;

  class Guard = G::Guard;

  class ConstantIntegerExpr = RU::ConstantIntegerExpr;

  class ConditionalExpr = J::ConditionalExpr;

  class AddExpr = J::AddExpr;

  class SubExpr = J::SubExpr;

  class RemExpr = J::RemExpr;

  class AssignAddExpr = J::AssignAddExpr;

  class AssignSubExpr = J::AssignSubExpr;

  class AndBitwiseExpr = J::AndBitwiseExpr;

  class AssignAndExpr = J::AssignAndExpr;

  class MulExpr = J::MulExpr;

  class AssignMulExpr = J::AssignMulExpr;

  class LShiftExpr = J::LShiftExpr;

  class AssignLShiftExpr = J::AssignLShiftExpr;

  predicate guardDirectlyControlsSsaRead = RU::guardDirectlyControlsSsaRead/3;

  predicate guardControlsSsaRead = RU::guardControlsSsaRead/3;

  predicate valueFlowStep = RU::valueFlowStep/3;

  predicate eqFlowCond = RU::eqFlowCond/5;

  predicate ssaUpdateStep = RU::ssaUpdateStep/3;

  Expr getAnExpr(BasicBlock bb) { result = bb.getANode() }

  private predicate id(BasicBlock x, BasicBlock y) { x = y }

  private predicate idOf(BasicBlock x, int y) = equivalenceRelation(id/2)(x, y)

  int getId(BasicBlock bb) { idOf(bb, result) }
}
