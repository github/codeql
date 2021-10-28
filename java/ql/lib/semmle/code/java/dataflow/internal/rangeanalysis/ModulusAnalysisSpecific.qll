module Private {
  private import java as J
  private import semmle.code.java.dataflow.SSA as Ssa
  private import semmle.code.java.dataflow.RangeUtils as RU
  private import semmle.code.java.controlflow.Guards as G
  private import semmle.code.java.controlflow.BasicBlocks as BB
  private import SsaReadPositionCommon

  class BasicBlock = BB::BasicBlock;

  class SsaVariable = Ssa::SsaVariable;

  class SsaPhiNode = Ssa::SsaPhiNode;

  class Expr = J::Expr;

  class Guard = G::Guard;

  class ConstantIntegerExpr = RU::ConstantIntegerExpr;

  class ConditionalExpr = J::ConditionalExpr;

  /** An addition or an assign-add expression. */
  class AddExpr extends J::Expr {
    AddExpr() { this instanceof J::AddExpr or this instanceof J::AssignAddExpr }

    /** Gets the LHS operand of this add expression. */
    Expr getLhs() {
      result = this.(J::AddExpr).getLeftOperand()
      or
      result = this.(J::AssignAddExpr).getDest()
    }

    /** Gets the RHS operand of this add expression. */
    Expr getRhs() {
      result = this.(J::AddExpr).getRightOperand()
      or
      result = this.(J::AssignAddExpr).getRhs()
    }
  }

  /** A subtraction or an assign-sub expression. */
  class SubExpr extends J::Expr {
    SubExpr() { this instanceof J::SubExpr or this instanceof J::AssignSubExpr }

    /** Gets the LHS operand of this subtraction expression. */
    Expr getLhs() {
      result = this.(J::SubExpr).getLeftOperand()
      or
      result = this.(J::AssignSubExpr).getDest()
    }

    /** Gets the RHS operand of this subtraction expression. */
    Expr getRhs() {
      result = this.(J::SubExpr).getRightOperand()
      or
      result = this.(J::AssignSubExpr).getRhs()
    }
  }

  class RemExpr = J::RemExpr;

  /** A multiplication or an assign-mul expression. */
  class MulExpr extends J::Expr {
    MulExpr() { this instanceof J::MulExpr or this instanceof J::AssignMulExpr }

    /** Gets an operand of this multiplication. */
    Expr getAnOperand() {
      result = this.(J::MulExpr).getAnOperand() or
      result = this.(J::AssignMulExpr).getSource()
    }
  }

  /** A left shift or an assign-lshift expression. */
  class LShiftExpr extends J::Expr {
    LShiftExpr() { this instanceof J::LShiftExpr or this instanceof J::AssignLShiftExpr }

    /** Gets the RHS operand of this shift. */
    Expr getRhs() {
      result = this.(J::LShiftExpr).getRightOperand() or
      result = this.(J::AssignLShiftExpr).getRhs()
    }
  }

  /** A bitwise and or an assign-and expression. */
  class BitwiseAndExpr extends J::Expr {
    BitwiseAndExpr() { this instanceof J::AndBitwiseExpr or this instanceof J::AssignAndExpr }

    /** Gets an operand of this bitwise and operation. */
    Expr getAnOperand() {
      result = this.(J::AndBitwiseExpr).getAnOperand() or
      result = this.(J::AssignAndExpr).getSource()
    }

    /** Holds if this expression has operands `e1` and `e2`. */
    predicate hasOperands(Expr e1, Expr e2) {
      this.getAnOperand() = e1 and
      this.getAnOperand() = e2 and
      e1 != e2
    }
  }

  predicate guardDirectlyControlsSsaRead = RU::guardDirectlyControlsSsaRead/3;

  predicate guardControlsSsaRead = RU::guardControlsSsaRead/3;

  predicate valueFlowStep = RU::valueFlowStep/3;

  predicate eqFlowCond = RU::eqFlowCond/5;

  predicate ssaUpdateStep = RU::ssaUpdateStep/3;

  Expr getABasicBlockExpr(BasicBlock bb) { result = bb.getANode() }

  private predicate id(BasicBlock x, BasicBlock y) { x = y }

  private predicate idOf(BasicBlock x, int y) = equivalenceRelation(id/2)(x, y)

  private int getId(BasicBlock bb) { idOf(bb, result) }

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
