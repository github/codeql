/**
 * Provides predicates for range and modulus analysis.
 */
private module Impl {
  private import csharp
  private import Ssa
  private import SsaUtils
  private import ConstantUtils
  private import SsaReadPositionCommon
  private import semmle.code.csharp.controlflow.Guards as G
  private import ControlFlowReachability

  private class BooleanValue = G::AbstractValues::BooleanValue;

  private class ExprNode = ControlFlow::Nodes::ExprNode;

  private class ExprChildReachability extends ControlFlowReachabilityConfiguration {
    ExprChildReachability() { this = "ExprChildReachability" }

    override predicate candidate(
      Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
    ) {
      e2 = e1.getAChild() and
      scope = e1 and
      exactScope = false and
      isSuccessor in [false, true]
    }
  }

  /** Holds if `parent` having child `child` implies `parentNode` having child `childNode`. */
  predicate hasChild(Expr parent, Expr child, ExprNode parentNode, ExprNode childNode) {
    any(ExprChildReachability x).hasExprPath(parent, parentNode, child, childNode)
  }

  /** Holds if SSA definition `def` equals `e + delta`. */
  predicate ssaUpdateStep(ExplicitDefinition def, ExprNode e, int delta) {
    exists(ControlFlow::Node cfn | cfn = def.getControlFlowNode() |
      e = cfn.(ExprNode::Assignment).getRValue() and delta = 0
      or
      e = cfn.(ExprNode::PostIncrExpr).getOperand() and delta = 1
      or
      e = cfn.(ExprNode::PreIncrExpr).getOperand() and delta = 1
      or
      e = cfn.(ExprNode::PostDecrExpr).getOperand() and delta = -1
      or
      e = cfn.(ExprNode::PreDecrExpr).getOperand() and delta = -1
    )
  }

  /** Holds if `e1 + delta` equals `e2`. */
  predicate valueFlowStep(ExprNode e2, ExprNode e1, int delta) {
    e2.(ExprNode::AssignExpr).getRValue() = e1 and delta = 0
    or
    e2.(ExprNode::UnaryPlusExpr).getOperand() = e1 and delta = 0
    or
    e2.(ExprNode::PostIncrExpr).getOperand() = e1 and delta = 0
    or
    e2.(ExprNode::PostDecrExpr).getOperand() = e1 and delta = 0
    or
    e2.(ExprNode::PreIncrExpr).getOperand() = e1 and delta = 1
    or
    e2.(ExprNode::PreDecrExpr).getOperand() = e1 and delta = -1
    or
    exists(ConstantIntegerExpr x |
      e2.(ExprNode::AddExpr).getAnOperand() = e1 and
      e2.(ExprNode::AddExpr).getAnOperand() = x and
      e1 != x and
      x.getIntValue() = delta
    )
    or
    exists(ConstantIntegerExpr x |
      e2.(ExprNode::SubExpr).getLeftOperand() = e1 and
      e2.(ExprNode::SubExpr).getRightOperand() = x and
      x.getIntValue() = -delta
    )
    or
    // Conditional expressions with only one branch can happen either
    // because of pruning or because of Boolean splitting. In such cases
    // the conditional expression has the same value as the branch.
    delta = 0 and
    e2 =
      any(ExprNode::ConditionalExpr ce |
        e1 = ce.getTrueExpr() and
        not exists(ce.getFalseExpr())
        or
        e1 = ce.getFalseExpr() and
        not exists(ce.getTrueExpr())
      )
  }

  /** An expression whose value may control the execution of another element. */
  class Guard extends Expr instanceof G::Guard {
    /**
     * Holds if basic block `bb` is guarded by this guard having value `v`.
     */
    predicate controlsBasicBlock(ControlFlow::BasicBlock bb, G::AbstractValue v) {
      super.controlsBasicBlock(bb, v)
    }

    /**
     * Holds if this guard is an equality test between `e1` and `e2`. If the test is
     * negated, that is `!=`, then `polarity` is false, otherwise `polarity` is
     * true.
     */
    predicate isEquality(ExprNode e1, ExprNode e2, boolean polarity) {
      exists(Expr e1_, Expr e2_ |
        e1 = unique(ExprNode cfn | hasChild(this, e1_, _, cfn) | cfn) and
        e2 = unique(ExprNode cfn | hasChild(this, e2_, _, cfn) | cfn) and
        super.isEquality(e1_, e2_, polarity)
      )
    }
  }

  private Guard eqFlowCondAbs(
    Definition def, ExprNode e, int delta, boolean isEq, G::AbstractValue v
  ) {
    exists(boolean eqpolarity |
      result.isEquality(ssaRead(def, delta), e, eqpolarity) and
      eqpolarity.booleanXor(v.(BooleanValue).getValue()).booleanNot() = isEq
    )
    or
    exists(G::AbstractValue v0 |
      G::Internal::impliesStep(result, v, eqFlowCondAbs(def, e, delta, isEq, v0), v0)
    )
  }

  /**
   * Gets a condition that tests whether `def` equals `e + delta`.
   *
   * If the condition evaluates to `testIsTrue`:
   * - `isEq = true`  : `def == e + delta`
   * - `isEq = false` : `def != e + delta`
   */
  Guard eqFlowCond(Definition def, ExprNode e, int delta, boolean isEq, boolean testIsTrue) {
    exists(BooleanValue v |
      result = eqFlowCondAbs(def, e, delta, isEq, v) and
      testIsTrue = v.getValue()
    )
  }

  /**
   * Holds if `guard` controls the position `controlled` with the value `testIsTrue`.
   */
  predicate guardControlsSsaRead(Guard guard, SsaReadPosition controlled, boolean testIsTrue) {
    exists(BooleanValue b | b.getValue() = testIsTrue |
      guard.controlsBasicBlock(controlled.(SsaReadPositionBlock).getBlock(), b)
    )
  }

  /**
   * Holds if property `p` matches `property` in `baseClass` or any overrides.
   */
  predicate propertyOverrides(Property p, string baseClass, string property) {
    exists(Property p2 |
      p2.getUnboundDeclaration().getDeclaringType().hasQualifiedName(baseClass) and
      p2.hasName(property)
    |
      p.overridesOrImplementsOrEquals(p2)
    )
  }
}

import Impl

/**
 * Provides classes for mapping CFG nodes to AST nodes, in a way that respects
 * control-flow splitting. For example, in
 *
 * ```csharp
 * int M(bool b)
 * {
 *     var i = b ? 1 : -1;
 *     i = i - 1;
 *     if (b)
 *         return 0;
 *     return i;
 * }
 * ```
 * the subtraction `i - 1` exists in two copies in the CFG. The class `SubExpr`
 * contains each copy, with split-respecting `getLeft/RightOperand()` predicates.
 */
module ExprNode {
  private import csharp as CS

  private class ExprNode = CS::ControlFlow::Nodes::ExprNode;

  private import Sign

  /** An assignable access. */
  class AssignableAccess extends ExprNode {
    override CS::AssignableAccess e;
  }

  /** A field access. */
  class FieldAccess extends ExprNode {
    override CS::FieldAccess e;
  }

  /** A character literal. */
  class CharLiteral extends ExprNode {
    override CS::CharLiteral e;
  }

  /** An integer literal. */
  class IntegerLiteral extends ExprNode {
    override CS::IntegerLiteral e;
  }

  /** A long literal. */
  class LongLiteral extends ExprNode {
    override CS::LongLiteral e;
  }

  /** A cast. */
  class CastExpr extends ExprNode {
    override CS::CastExpr e;

    /** Gets the source type of this cast. */
    CS::Type getSourceType() { result = e.getSourceType() }
  }

  /** A floating point literal. */
  class RealLiteral extends ExprNode {
    override CS::RealLiteral e;
  }

  /** An assignment. */
  class Assignment extends ExprNode {
    override CS::Assignment e;

    /** Gets the left operand of this assignment. */
    ExprNode getLValue() {
      result = unique(ExprNode res | hasChild(e, e.getLValue(), this, res) | res)
    }

    /** Gets the right operand of this assignment. */
    ExprNode getRValue() {
      result = unique(ExprNode res | hasChild(e, e.getRValue(), this, res) | res)
    }
  }

  /** A simple assignment. */
  class AssignExpr extends Assignment {
    override CS::AssignExpr e;
  }

  /** A unary operation. */
  class UnaryOperation extends ExprNode {
    override CS::UnaryOperation e;

    /** Returns the operand of this unary operation. */
    ExprNode getOperand() {
      result = unique(ExprNode res | hasChild(e, e.getOperand(), this, res) | res)
    }

    /** Returns the operation representing this unary operation. */
    TUnarySignOperation getOp() { none() }
  }

  /** A prefix increment operation. */
  class PreIncrExpr extends UnaryOperation {
    override CS::PreIncrExpr e;

    override TIncOp getOp() { any() }
  }

  /** A postfix increment operation. */
  class PostIncrExpr extends UnaryOperation {
    override CS::PostIncrExpr e;
  }

  /** A prefix decrement operation. */
  class PreDecrExpr extends UnaryOperation {
    override CS::PreDecrExpr e;

    override TDecOp getOp() { any() }
  }

  /** A postfix decrement operation. */
  class PostDecrExpr extends UnaryOperation {
    override CS::PostDecrExpr e;
  }

  /** A unary plus operation. */
  class UnaryPlusExpr extends UnaryOperation {
    override CS::UnaryPlusExpr e;
  }

  /** A unary minus operation. */
  class UnaryMinusExpr extends UnaryOperation {
    override CS::UnaryMinusExpr e;

    override TNegOp getOp() { any() }
  }

  /** A bitwise complement operation. */
  class ComplementExpr extends UnaryOperation {
    override CS::ComplementExpr e;

    override TBitNotOp getOp() { any() }
  }

  /** A binary operation. */
  class BinaryOperation extends ExprNode {
    override CS::BinaryOperation e;

    /** Returns the operation representing this binary operation. */
    TBinarySignOperation getOp() { none() }

    /** Gets the left operand of this binary operation. */
    ExprNode getLeftOperand() {
      result = unique(ExprNode res | hasChild(e, e.getLeftOperand(), this, res) | res)
    }

    /** Gets the right operand of this binary operation. */
    ExprNode getRightOperand() {
      result = unique(ExprNode res | hasChild(e, e.getRightOperand(), this, res) | res)
    }

    /** Gets the left operand of this binary operation. */
    ExprNode getLhs() { result = this.getLeftOperand() }

    /** Gets the right operand of this binary operation. */
    ExprNode getRhs() { result = this.getRightOperand() }

    /** Gets an operand of this binary operation. */
    ExprNode getAnOperand() { hasChild(e, e.getAnOperand(), this, result) }

    /** Holds if this binary operation has operands `e1` and `e2`. */
    predicate hasOperands(ExprNode e1, ExprNode e2) {
      this.getAnOperand() = e1 and
      this.getAnOperand() = e2 and
      e1 != e2
    }
  }

  /** An addition operation. */
  class AddExpr extends BinaryOperation {
    override CS::AddExpr e;

    override TAddOp getOp() { any() }
  }

  /** A subtraction operation. */
  class SubExpr extends BinaryOperation {
    override CS::SubExpr e;

    override TSubOp getOp() { any() }
  }

  /** A multiplication operation. */
  class MulExpr extends BinaryOperation {
    override CS::MulExpr e;

    override TMulOp getOp() { any() }
  }

  /** A division operation. */
  class DivExpr extends BinaryOperation {
    override CS::DivExpr e;

    override TDivOp getOp() { any() }
  }

  /** A remainder operation. */
  class RemExpr extends BinaryOperation {
    override CS::RemExpr e;

    override TRemOp getOp() { any() }
  }

  /** A bitwise-and operation. */
  class BitwiseAndExpr extends BinaryOperation {
    override CS::BitwiseAndExpr e;

    override TBitAndOp getOp() { any() }
  }

  /** A bitwise-or operation. */
  class BitwiseOrExpr extends BinaryOperation {
    override CS::BitwiseOrExpr e;

    override TBitOrOp getOp() { any() }
  }

  /** A bitwise-xor operation. */
  class BitwiseXorExpr extends BinaryOperation {
    override CS::BitwiseXorExpr e;

    override TBitXorOp getOp() { any() }
  }

  /** A left-shift operation. */
  class LShiftExpr extends BinaryOperation {
    override CS::LShiftExpr e;

    override TLShiftOp getOp() { any() }
  }

  /** A right-shift operation. */
  class RShiftExpr extends BinaryOperation {
    override CS::RShiftExpr e;

    override TRShiftOp getOp() { any() }
  }

  /** A conditional expression. */
  class ConditionalExpr extends ExprNode {
    override CS::ConditionalExpr e;

    /** Gets the "then" expression of this conditional expression. */
    ExprNode getTrueExpr() { hasChild(e, e.getThen(), this, result) }

    /** Gets the "else" expression of this conditional expression. */
    ExprNode getFalseExpr() { hasChild(e, e.getElse(), this, result) }

    /**
     * If `branch` is `true` gets the "then" expression, if `false` gets the
     * "else" expression of this conditional expression.
     */
    ExprNode getBranchExpr(boolean branch) {
      branch = true and result = this.getTrueExpr()
      or
      branch = false and result = this.getFalseExpr()
    }
  }
}
