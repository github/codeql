module Private {
  private import csharp as CS
  private import ConstantUtils as CU
  private import semmle.code.csharp.controlflow.Guards as G
  private import semmle.code.csharp.dataflow.internal.rangeanalysis.RangeUtils as RU
  private import SsaUtils as SU
  private import SignAnalysisSpecific::Private as SA

  class BasicBlock = CS::Ssa::BasicBlock;

  class SsaVariable extends CS::Ssa::Definition {
    CS::AssignableRead getAUse() { result = this.getARead() }
  }

  class SsaPhiNode = CS::Ssa::PhiNode;

  class Expr = CS::Expr;

  class Guard = G::Guard;

  class ConstantIntegerExpr = CU::ConstantIntegerExpr;

  class ConditionalExpr extends CS::ConditionalExpr {
    /** Gets the "then" expression of this conditional expression. */
    Expr getTrueExpr() { result = this.getThen() }

    /** Gets the "else" expression of this conditional expression. */
    Expr getFalseExpr() { result = this.getElse() }
  }

  class AddExpr = CS::AddExpr;

  class SubExpr = CS::SubExpr;

  class RemExpr = CS::RemExpr;

  class AssignAddExpr extends CS::AssignAddExpr {
    /** Gets the left operand of this assignment. */
    Expr getDest() { result = this.getLValue() }

    /** Gets the right operand of this assignment. */
    Expr getRhs() { result = this.getRValue() }
  }

  class AssignSubExpr extends CS::AssignSubExpr {
    /** Gets the left operand of this assignment. */
    Expr getDest() { result = this.getLValue() }

    /** Gets the right operand of this assignment. */
    Expr getRhs() { result = this.getRValue() }
  }

  class AndBitwiseExpr extends CS::BitwiseAndExpr {
    predicate hasOperands(Expr e1, Expr e2) {
      (
        this.getAnOperand() = e1 or
        this.getAnOperand() = e2
      ) and
      e1 != e2
    }
  }

  class AssignAndExpr extends CS::AssignAndExpr {
    /** Gets the an operand of this assignment. */
    Expr getSource() { result = this.getRValue() or result = this.getLValue() }
  }

  class MulExpr = CS::MulExpr;

  class AssignMulExpr extends CS::AssignMulExpr {
    /** Gets the an operand of this assignment. */
    Expr getSource() { result = this.getRValue() or result = this.getLValue() }
  }

  class LShiftExpr = CS::LShiftExpr;

  class AssignLShiftExpr extends CS::AssignLShiftExpr {
    /** Gets the right operand of this assignment. */
    Expr getRhs() { result = this.getRValue() }
  }

  predicate guardDirectlyControlsSsaRead = SA::guardControlsSsaRead/3;

  predicate guardControlsSsaRead = SA::guardControlsSsaRead/3;

  predicate valueFlowStep = RU::valueFlowStep/3;

  predicate eqFlowCond = RU::eqFlowCond/5;

  predicate ssaUpdateStep = RU::ssaUpdateStep/3;

  Expr getAnExpr(BasicBlock bb) { result = bb.getANode().getElement() }

  private predicate id(CS::ControlFlowElement x, CS::ControlFlowElement y) { x = y }

  private predicate idOf(CS::ControlFlowElement x, int y) = equivalenceRelation(id/2)(x, y)

  int getId(BasicBlock bb) { idOf(bb.getFirstNode().getElement(), result) }
}
