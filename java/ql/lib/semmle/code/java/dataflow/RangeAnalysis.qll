/**
 * Provides classes and predicates for range analysis.
 *
 * An inferred bound can either be a specific integer, the abstract value of an
 * SSA variable, or the abstract value of an interesting expression. The latter
 * category includes array lengths that are not SSA variables.
 *
 * If an inferred bound relies directly on a condition, then this condition is
 * reported as the reason for the bound.
 */

/*
 * This library tackles range analysis as a flow problem. Consider e.g.:
 * ```
 *   len = arr.length;
 *   if (x < len) { ... y = x-1; ... y ... }
 * ```
 * In this case we would like to infer `y <= arr.length - 2`, and this is
 * accomplished by tracking the bound through a sequence of steps:
 * ```
 *   arr.length --> len = .. --> x < len --> x-1 --> y = .. --> y
 * ```
 *
 * In its simplest form the step relation `E1 --> E2` relates two expressions
 * such that `E1 <= B` implies `E2 <= B` for any `B` (with a second separate
 * step relation handling lower bounds). Examples of such steps include
 * assignments `E2 = E1` and conditions `x <= E1` where `E2` is a use of `x`
 * guarded by the condition.
 *
 * In order to handle subtractions and additions with constants, and strict
 * comparisons, the step relation is augmented with an integer delta. With this
 * generalization `E1 --(delta)--> E2` relates two expressions and an integer
 * such that `E1 <= B` implies `E2 <= B + delta` for any `B`. This corresponds
 * to the predicate `boundFlowStep`.
 *
 * The complete range analysis is then implemented as the transitive closure of
 * the step relation summing the deltas along the way. If `E1` transitively
 * steps to `E2`, `delta` is the sum of deltas along the path, and `B` is an
 * interesting bound equal to the value of `E1` then `E2 <= B + delta`. This
 * corresponds to the predicate `bounded`.
 *
 * Phi nodes need a little bit of extra handling. Consider `x0 = phi(x1, x2)`.
 * There are essentially two cases:
 * - If `x1 <= B + d1` and `x2 <= B + d2` then `x0 <= B + max(d1,d2)`.
 * - If `x1 <= B + d1` and `x2 <= x0 + d2` with `d2 <= 0` then `x0 <= B + d1`.
 * The first case is for whenever a bound can be proven without taking looping
 * into account. The second case is relevant when `x2` comes from a back-edge
 * where we can prove that the variable has been non-increasing through the
 * loop-iteration as this means that any upper bound that holds prior to the
 * loop also holds for the variable during the loop.
 * This generalizes to a phi node with `n` inputs, so if
 * `x0 = phi(x1, ..., xn)` and `xi <= B + delta` for one of the inputs, then we
 * also have `x0 <= B + delta` if we can prove either:
 * - `xj <= B + d` with `d <= delta` or
 * - `xj <= x0 + d` with `d <= 0`
 * for each input `xj`.
 *
 * As all inferred bounds can be related directly to a path in the source code
 * the only source of non-termination is if successive redundant (and thereby
 * increasingly worse) bounds are calculated along a loop in the source code.
 * We prevent this by weakening the bound to a small finite set of bounds when
 * a path follows a second back-edge (we postpone weakening till the second
 * back-edge as a precise bound might require traversing a loop once).
 */

import java
private import SSA
private import RangeUtils
private import semmle.code.java.controlflow.internal.GuardsLogic
private import semmle.code.java.security.RandomDataSource
private import SignAnalysis
private import semmle.code.java.Reflection
private import semmle.code.java.Collections
private import semmle.code.java.Maps
import Bound
private import codeql.rangeanalysis.RangeAnalysis

module Sem implements Semantic<Location> {
  private import java as J
  private import SSA as SSA
  private import RangeUtils as RU
  private import semmle.code.java.controlflow.internal.GuardsLogic as GL

  class Expr = J::Expr;

  class ConstantIntegerExpr = RU::ConstantIntegerExpr;

  abstract class BinaryExpr extends Expr {
    Expr getLeftOperand() {
      result = this.(J::BinaryExpr).getLeftOperand() or result = this.(J::AssignOp).getDest()
    }

    Expr getRightOperand() {
      result = this.(J::BinaryExpr).getRightOperand() or result = this.(J::AssignOp).getRhs()
    }

    final Expr getAnOperand() { result = this.getLeftOperand() or result = this.getRightOperand() }

    final predicate hasOperands(Expr e1, Expr e2) {
      this.getLeftOperand() = e1 and this.getRightOperand() = e2
      or
      this.getLeftOperand() = e2 and this.getRightOperand() = e1
    }
  }

  class AddExpr extends BinaryExpr {
    AddExpr() { this instanceof J::AddExpr or this instanceof J::AssignAddExpr }
  }

  class SubExpr extends BinaryExpr {
    SubExpr() { this instanceof J::SubExpr or this instanceof J::AssignSubExpr }
  }

  class MulExpr extends BinaryExpr {
    MulExpr() { this instanceof J::MulExpr or this instanceof J::AssignMulExpr }
  }

  class DivExpr extends BinaryExpr {
    DivExpr() { this instanceof J::DivExpr or this instanceof J::AssignDivExpr }
  }

  class RemExpr extends BinaryExpr {
    RemExpr() { this instanceof J::RemExpr or this instanceof J::AssignRemExpr }
  }

  class BitAndExpr extends BinaryExpr {
    BitAndExpr() { this instanceof J::AndBitwiseExpr or this instanceof J::AssignAndExpr }
  }

  class BitOrExpr extends BinaryExpr {
    BitOrExpr() { this instanceof J::OrBitwiseExpr or this instanceof J::AssignOrExpr }
  }

  class ShiftLeftExpr extends BinaryExpr {
    ShiftLeftExpr() { this instanceof J::LeftShiftExpr or this instanceof J::AssignLeftShiftExpr }
  }

  class ShiftRightExpr extends BinaryExpr {
    ShiftRightExpr() {
      this instanceof J::RightShiftExpr or this instanceof J::AssignRightShiftExpr
    }
  }

  class ShiftRightUnsignedExpr extends BinaryExpr {
    ShiftRightUnsignedExpr() {
      this instanceof J::UnsignedRightShiftExpr or this instanceof J::AssignUnsignedRightShiftExpr
    }
  }

  predicate isAssignOp(BinaryExpr bin) { bin instanceof AssignOp }

  class RelationalExpr = J::ComparisonExpr;

  abstract class UnaryExpr extends Expr {
    abstract Expr getOperand();
  }

  class ConvertExpr extends UnaryExpr instanceof CastingExpr {
    override Expr getOperand() { result = super.getExpr() }
  }

  class BoxExpr extends UnaryExpr {
    BoxExpr() { none() }

    override Expr getOperand() { none() }
  }

  class UnboxExpr extends UnaryExpr {
    UnboxExpr() { none() }

    override Expr getOperand() { none() }
  }

  class NegateExpr extends UnaryExpr instanceof MinusExpr {
    override Expr getOperand() { result = super.getExpr() }
  }

  class PreIncExpr extends UnaryExpr instanceof J::PreIncExpr {
    override Expr getOperand() { result = super.getExpr() }
  }

  class PreDecExpr extends UnaryExpr instanceof J::PreDecExpr {
    override Expr getOperand() { result = super.getExpr() }
  }

  class PostIncExpr extends UnaryExpr instanceof J::PostIncExpr {
    override Expr getOperand() { result = super.getExpr() }
  }

  class PostDecExpr extends UnaryExpr instanceof J::PostDecExpr {
    override Expr getOperand() { result = super.getExpr() }
  }

  class CopyValueExpr extends UnaryExpr {
    CopyValueExpr() {
      this instanceof J::PlusExpr or
      this instanceof J::AssignExpr or
      this instanceof LocalVariableDeclExpr
    }

    override Expr getOperand() {
      result = this.(J::PlusExpr).getExpr() or
      result = this.(J::AssignExpr).getSource() or
      result = this.(J::LocalVariableDeclExpr).getInit()
    }
  }

  class ConditionalExpr = J::ConditionalExpr;

  class BasicBlock = J::BasicBlock;

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getABBSuccessor() }

  private predicate id(ExprParent x, ExprParent y) { x = y }

  private predicate idOfAst(ExprParent x, int y) = equivalenceRelation(id/2)(x, y)

  private predicate idOf(BasicBlock x, int y) { idOfAst(x.getAstNode(), y) }

  int getBlockId1(BasicBlock bb) { idOf(bb, result) }

  final private class FinalGuard = GL::Guard;

  class Guard extends FinalGuard {
    Expr asExpr() { result = this }
  }

  predicate implies_v2(Guard g1, boolean b1, Guard g2, boolean b2) {
    GL::implies_v2(g1, b1, g2, b2)
  }

  class Type = J::Type;

  class IntegerType extends J::IntegralType {
    predicate isSigned() { not this instanceof CharacterType }
  }

  class FloatingPointType extends Type {
    FloatingPointType() { none() }
  }

  class AddressType extends Type {
    AddressType() { none() }
  }

  Type getExprType(Expr e) { result = e.getType() }

  Type getSsaType(SsaVariable var) { result = var.getSourceVariable().getType() }

  final private class FinalSsaVariable = SSA::SsaVariable;

  class SsaVariable extends FinalSsaVariable {
    Expr getAUse() { result = super.getAUse() }
  }

  class SsaPhiNode extends SsaVariable instanceof SSA::SsaPhiNode {
    predicate hasInputFromBlock(SsaVariable inp, BasicBlock bb) { super.hasInputFromBlock(inp, bb) }
  }

  class SsaExplicitUpdate extends SsaVariable instanceof SSA::SsaExplicitUpdate {
    Expr getDefiningExpr() { result = super.getDefiningExpr() }
  }

  predicate additionalValueFlowStep = RU::additionalValueFlowStep/3;

  predicate conversionCannotOverflow = safeCast/2;
}

module SignInp implements SignAnalysisSig<Location, Sem> {
  private import SignAnalysis
  private import internal.rangeanalysis.Sign

  predicate semPositive = positive/1;

  predicate semNegative = negative/1;

  predicate semStrictlyPositive = strictlyPositive/1;

  predicate semStrictlyNegative = strictlyNegative/1;

  predicate semMayBePositive(Sem::Expr e) { exprSign(e) = TPos() }

  predicate semMayBeNegative(Sem::Expr e) { exprSign(e) = TNeg() }
}

module Modulus implements ModulusAnalysisSig<Location, Sem> {
  class ModBound = Bound;

  private import codeql.rangeanalysis.ModulusAnalysis as Mod
  import Mod::ModulusAnalysis<Location, Sem, IntDelta, Bounds>
}

module IntDelta implements DeltaSig {
  class Delta = int;

  bindingset[d]
  bindingset[result]
  float toFloat(Delta d) { result = d }

  bindingset[d]
  bindingset[result]
  int toInt(Delta d) { result = d }

  bindingset[n]
  bindingset[result]
  Delta fromInt(int n) { result = n }

  bindingset[f]
  Delta fromFloat(float f) { result = f }
}

module JavaLangImpl implements LangSig<Location, Sem, IntDelta> {
  /**
   * Holds if `e >= bound` (if `upper = false`) or `e <= bound` (if `upper = true`).
   */
  predicate hasConstantBound(Sem::Expr e, int bound, boolean upper) {
    (
      e.(MethodCall).getMethod() instanceof StringLengthMethod or
      e.(MethodCall).getMethod() instanceof CollectionSizeMethod or
      e.(MethodCall).getMethod() instanceof MapSizeMethod or
      e.(FieldRead).getField() instanceof ArrayLengthField
    ) and
    bound = 0 and
    upper = false
    or
    exists(Method read |
      e.(MethodCall).getMethod().overrides*(read) and
      read.getDeclaringType() instanceof TypeInputStream and
      read.hasName("read") and
      read.getNumberOfParameters() = 0
    |
      upper = true and bound = 255
      or
      upper = false and bound = -1
    )
  }

  /**
   * Holds if `e2 >= e1 + delta` (if `upper = false`) or `e2 <= e1 + delta` (if `upper = true`).
   */
  predicate additionalBoundFlowStep(Sem::Expr e2, Sem::Expr e1, int delta, boolean upper) {
    exists(RandomDataSource rds |
      e2 = rds.getOutput() and
      (
        e1 = rds.getUpperBoundExpr() and
        delta = -1 and
        upper = true
        or
        e1 = rds.getLowerBoundExpr() and
        delta = 0 and
        upper = false
      )
    )
    or
    exists(MethodCall ma, Method m |
      e2 = ma and
      ma.getMethod() = m and
      (
        m.hasName("max") and upper = false
        or
        m.hasName("min") and upper = true
      ) and
      m.getDeclaringType().hasQualifiedName("java.lang", "Math") and
      e1 = ma.getAnArgument() and
      delta = 0
    )
  }

  predicate ignoreExprBound(Sem::Expr e) { none() }

  predicate javaCompatibility() { any() }
}

module Bounds implements BoundSig<Location, Sem, IntDelta> {
  class SemBound = Bound;

  class SemZeroBound = ZeroBound;

  class SemSsaBound extends SsaBound {
    Sem::SsaVariable getVariable() { result = super.getSsa() }
  }
}

module Overflow implements OverflowSig<Location, Sem, IntDelta> {
  predicate semExprDoesNotOverflow(boolean positively, Sem::Expr expr) {
    positively = [true, false] and exists(expr)
  }
}

module Range =
  RangeStage<Location, Sem, IntDelta, Bounds, Overflow, JavaLangImpl, SignInp, Modulus>;

predicate bounded = Range::semBounded/5;

class Reason = Range::SemReason;

class NoReason = Range::SemNoReason;

class CondReason = Range::SemCondReason;

/**
 * Holds if a cast from `fromtyp` to `totyp` can be ignored for the purpose of
 * range analysis.
 */
private predicate safeCast(Type fromtyp, Type totyp) {
  exists(PrimitiveType pfrom, PrimitiveType pto | pfrom = fromtyp and pto = totyp |
    pfrom = pto
    or
    pfrom.hasName("char") and pto.hasName(["int", "long", "float", "double"])
    or
    pfrom.hasName("byte") and pto.hasName(["short", "int", "long", "float", "double"])
    or
    pfrom.hasName("short") and pto.hasName(["int", "long", "float", "double"])
    or
    pfrom.hasName("int") and pto.hasName(["long", "float", "double"])
    or
    pfrom.hasName("long") and pto.hasName(["float", "double"])
    or
    pfrom.hasName("float") and pto.hasName("double")
    or
    pfrom.hasName("double") and pto.hasName("float")
  )
  or
  safeCast(fromtyp.(BoxedType).getPrimitiveType(), totyp)
  or
  safeCast(fromtyp, totyp.(BoxedType).getPrimitiveType())
}
