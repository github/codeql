module Private {
  private import java as J
  private import semmle.code.java.dataflow.SSA as Ssa
  private import semmle.code.java.dataflow.RangeUtils as RU
  private import semmle.code.java.controlflow.Guards as G
  private import semmle.code.java.controlflow.BasicBlocks as BB
  private import semmle.code.java.controlflow.internal.GuardsLogic as GL
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
  class LeftShiftExpr extends J::Expr {
    LeftShiftExpr() { this instanceof J::LeftShiftExpr or this instanceof J::AssignLeftShiftExpr }

    /** Gets the RHS operand of this shift. */
    Expr getRhs() {
      result = this.(J::LeftShiftExpr).getRightOperand() or
      result = this.(J::AssignLeftShiftExpr).getRhs()
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

  /**
   * Holds if `guard` directly controls the position `controlled` with the
   * value `testIsTrue`.
   */
  pragma[nomagic]
  predicate guardDirectlyControlsSsaRead(Guard guard, SsaReadPosition controlled, boolean testIsTrue) {
    guard.directlyControls(controlled.(SsaReadPositionBlock).getBlock(), testIsTrue)
    or
    exists(SsaReadPositionPhiInputEdge controlledEdge | controlledEdge = controlled |
      guard.directlyControls(controlledEdge.getOrigBlock(), testIsTrue) or
      guard.hasBranchEdge(controlledEdge.getOrigBlock(), controlledEdge.getPhiBlock(), testIsTrue)
    )
  }

  /**
   * Holds if `guard` controls the position `controlled` with the value `testIsTrue`.
   */
  predicate guardControlsSsaRead(Guard guard, SsaReadPosition controlled, boolean testIsTrue) {
    guardDirectlyControlsSsaRead(guard, controlled, testIsTrue)
    or
    exists(Guard guard0, boolean testIsTrue0 |
      GL::implies_v2(guard0, testIsTrue0, guard, testIsTrue) and
      guardControlsSsaRead(guard0, controlled, testIsTrue0)
    )
  }

  predicate valueFlowStep = RU::valueFlowStep/3;

  predicate eqFlowCond = RU::eqFlowCond/5;

  predicate ssaUpdateStep = RU::ssaUpdateStep/3;

  Expr getABasicBlockExpr(BasicBlock bb) { result = bb.getANode().asExpr() }
}
