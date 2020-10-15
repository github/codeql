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

  /** Represent an addition expression. */
  class AddExpr extends CS::AddExpr {
    /** Gets the LHS operand of this add expression. */
    Expr getLhs() { result = this.getLeftOperand() }

    /** Gets the RHS operand of this add expression. */
    Expr getRhs() { result = this.getRightOperand() }
  }

  /** Represent a subtraction expression. */
  class SubExpr extends CS::SubExpr {
    /** Gets the LHS operand of this subtraction expression. */
    Expr getLhs() { result = this.getLeftOperand() }

    /** Gets the RHS operand of this subtraction expression. */
    Expr getRhs() { result = this.getRightOperand() }
  }

  class RemExpr = CS::RemExpr;

  /** Represent a bitwise and or an assign-and expression. */
  class BitwiseAndExpr extends CS::Expr {
    BitwiseAndExpr() { this instanceof CS::BitwiseAndExpr or this instanceof CS::AssignAndExpr }

    /** Gets an operand of this bitwise and operation. */
    Expr getAnOperand() {
      result = this.(CS::BitwiseAndExpr).getAnOperand() or
      result = this.(CS::AssignAndExpr).getRValue() or
      result = this.(CS::AssignAndExpr).getLValue()
    }

    /** Holds if this expression has operands `e1` and `e2`. */
    predicate hasOperands(Expr e1, Expr e2) {
      this.getAnOperand() = e1 and
      this.getAnOperand() = e2 and
      e1 != e2
    }
  }

  /** Represent a multiplication or an assign-mul expression. */
  class MulExpr extends CS::Expr {
    MulExpr() { this instanceof CS::MulExpr or this instanceof CS::AssignMulExpr }

    /** Gets an operand of this multiplication. */
    Expr getAnOperand() {
      result = this.(CS::MulExpr).getAnOperand() or
      result = this.(CS::AssignMulExpr).getRValue() or
      result = this.(CS::AssignMulExpr).getLValue()
    }
  }

  /** Represent a left shift or an assign-lshift expression. */
  class LShiftExpr extends CS::Expr {
    LShiftExpr() { this instanceof CS::LShiftExpr or this instanceof CS::AssignLShiftExpr }

    /** Gets the RHS operand of this shift. */
    Expr getRhs() {
      result = this.(CS::LShiftExpr).getRightOperand() or
      result = this.(CS::AssignLShiftExpr).getRValue()
    }
  }

  predicate guardDirectlyControlsSsaRead = SA::guardControlsSsaRead/3;

  predicate guardControlsSsaRead = SA::guardControlsSsaRead/3;

  predicate valueFlowStep = RU::valueFlowStep/3;

  predicate eqFlowCond = RU::eqFlowCond/5;

  predicate ssaUpdateStep = RU::ssaUpdateStep/3;

  Expr getABasicBlockExpr(BasicBlock bb) { result = bb.getANode().getElement() }

  private predicate id(CS::ControlFlowElement x, CS::ControlFlowElement y) { x = y }

  private predicate idOf(CS::ControlFlowElement x, int y) = equivalenceRelation(id/2)(x, y)

  int getId(BasicBlock bb) { idOf(bb.getFirstNode().getElement(), result) }
}
