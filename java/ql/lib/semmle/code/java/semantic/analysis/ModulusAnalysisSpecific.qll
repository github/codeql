module Private {
  private import java as J
  private import semmle.code.java.controlflow.BasicBlocks as BB
  private import semmle.code.java.semantic.SemanticCFG
  private import semmle.code.java.semantic.SemanticExpr
  private import semmle.code.java.semantic.SemanticSSA

  /** An addition or an assign-add expression. */
  class AddExpr extends SemExpr {
    AddExpr() { this instanceof SemAddExpr or this instanceof SemAssignAddExpr }

    /** Gets the LHS operand of this add expression. */
    SemExpr getLhs() {
      result = this.(SemAddExpr).getLeftOperand()
      or
      result = this.(SemAssignAddExpr).getDest()
    }

    /** Gets the RHS operand of this add expression. */
    SemExpr getRhs() {
      result = this.(SemAddExpr).getRightOperand()
      or
      result = this.(SemAssignAddExpr).getRhs()
    }
  }

  /** A subtraction or an assign-sub expression. */
  class SubExpr extends SemExpr {
    SubExpr() { this instanceof SemSubExpr or this instanceof SemAssignSubExpr }

    /** Gets the LHS operand of this subtraction expression. */
    SemExpr getLhs() {
      result = this.(SemSubExpr).getLeftOperand()
      or
      result = this.(SemAssignSubExpr).getDest()
    }

    /** Gets the RHS operand of this subtraction expression. */
    SemExpr getRhs() {
      result = this.(SemSubExpr).getRightOperand()
      or
      result = this.(SemAssignSubExpr).getRhs()
    }
  }

  /** A multiplication or an assign-mul expression. */
  class MulExpr extends SemExpr {
    MulExpr() { this instanceof SemMulExpr or this instanceof SemAssignMulExpr }

    /** Gets an operand of this multiplication. */
    SemExpr getAnOperand() {
      result = this.(SemMulExpr).getAnOperand() or
      result = this.(SemAssignMulExpr).getSource()
    }
  }

  /** A left shift or an assign-lshift expression. */
  class LShiftExpr extends SemExpr {
    LShiftExpr() { this instanceof SemLShiftExpr or this instanceof SemAssignLShiftExpr }

    /** Gets the RHS operand of this shift. */
    SemExpr getRhs() {
      result = this.(SemLShiftExpr).getRightOperand() or
      result = this.(SemAssignLShiftExpr).getRhs()
    }
  }

  /** A bitwise and or an assign-and expression. */
  class BitwiseAndExpr extends SemExpr {
    BitwiseAndExpr() { this instanceof SemAndBitwiseExpr or this instanceof SemAssignAndExpr }

    /** Gets an operand of this bitwise and operation. */
    SemExpr getAnOperand() {
      result = this.(SemAndBitwiseExpr).getAnOperand() or
      result = this.(SemAssignAndExpr).getSource()
    }

    /** Holds if this expression has operands `e1` and `e2`. */
    predicate hasOperands(SemExpr e1, SemExpr e2) {
      this.getAnOperand() = e1 and
      this.getAnOperand() = e2 and
      e1 != e2
    }
  }

  private predicate id(BB::BasicBlock x, BB::BasicBlock y) { x = y }

  private predicate idOf(BB::BasicBlock x, int y) = equivalenceRelation(id/2)(x, y)

  private int getId(BB::BasicBlock bb) { idOf(bb, result) }

  /**
   * Holds if `inp` is an input to `phi` along `edge` and this input has index `r`
   * in an arbitrary 1-based numbering of the input edges to `phi`.
   */
  predicate rankedPhiInput(
    SemSsaPhiNode phi, SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge, int r
  ) {
    edge.phiInput(phi, inp) and
    edge =
      rank[r](SemSsaReadPositionPhiInputEdge e |
        e.phiInput(phi, _)
      |
        e order by getId(getJavaBasicBlock(e.getOrigBlock()))
      )
  }
}
