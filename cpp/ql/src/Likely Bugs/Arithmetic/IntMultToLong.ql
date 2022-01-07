/**
 * @name Multiplication result converted to larger type
 * @description A multiplication result that is converted to a larger type can
 *              be a sign that the result can overflow the type converted from.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision high
 * @id cpp/integer-multiplication-cast-to-long
 * @tags reliability
 *       security
 *       correctness
 *       types
 *       external/cwe/cwe-190
 *       external/cwe/cwe-192
 *       external/cwe/cwe-197
 *       external/cwe/cwe-681
 */

import cpp
import semmle.code.cpp.controlflow.SSA
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils

/**
 * Holds if `e` is either:
 *  - a constant
 *  - a char-typed expression, meaning it's a small number
 *  - an array access to an array of constants
 *  - flows from one of the above
 * In these cases the value of `e` is likely to be small and
 * controlled, so we consider it less likely to cause an overflow.
 */
predicate likelySmall(Expr e) {
  e.isConstant()
  or
  e.getType().getSize() <= 1
  or
  e.(ArrayExpr).getArrayBase().getType().(ArrayType).getBaseType().isConst()
  or
  exists(SsaDefinition def, Variable v |
    def.getAUse(v) = e and
    likelySmall(def.getDefiningValue(v))
  )
}

/**
 * Gets an operand of a multiply expression (we need the restriction
 * to multiply expressions to get the correct transitive closure).
 */
Expr getMulOperand(MulExpr me) { result = me.getAnOperand() }

/**
 * Gets the number of non-constant operands of a multiply expression,
 * exploring into child multiply expressions rather than counting them
 * as an operand directly.  For example the top level multiply here
 * effectively has two non-constant operands:
 * ```
 *   (x * y) * 2
 * ```
 */
int getEffectiveMulOperands(MulExpr me) {
  result =
    count(Expr op |
      op = getMulOperand*(me) and
      not op instanceof MulExpr and
      not likelySmall(op)
    )
}

/**
 * As SimpleRangeAnalysis does not support reasoning about multiplication
 * we create a tiny abstract interpreter for handling multiplication, which
 * we invoke only after weeding out of all of trivial cases that we do
 * not care about. By default, the maximum and minimum values are computed
 * using SimpleRangeAnalysis.
 */
class AnalyzableExpr extends Expr {
  float maxValue() { result = upperBound(this.getFullyConverted()) }

  float minValue() { result = lowerBound(this.getFullyConverted()) }
}

class ParenAnalyzableExpr extends AnalyzableExpr, ParenthesisExpr {
  override float maxValue() { result = this.getExpr().(AnalyzableExpr).maxValue() }

  override float minValue() { result = this.getExpr().(AnalyzableExpr).minValue() }
}

class MulAnalyzableExpr extends AnalyzableExpr, MulExpr {
  override float maxValue() {
    exists(float x1, float y1, float x2, float y2 |
      x1 = this.getLeftOperand().getFullyConverted().(AnalyzableExpr).minValue() and
      x2 = this.getLeftOperand().getFullyConverted().(AnalyzableExpr).maxValue() and
      y1 = this.getRightOperand().getFullyConverted().(AnalyzableExpr).minValue() and
      y2 = this.getRightOperand().getFullyConverted().(AnalyzableExpr).maxValue() and
      result = (x1 * y1).maximum(x1 * y2).maximum(x2 * y1).maximum(x2 * y2)
    )
  }

  override float minValue() {
    exists(float x1, float x2, float y1, float y2 |
      x1 = this.getLeftOperand().getFullyConverted().(AnalyzableExpr).minValue() and
      x2 = this.getLeftOperand().getFullyConverted().(AnalyzableExpr).maxValue() and
      y1 = this.getRightOperand().getFullyConverted().(AnalyzableExpr).minValue() and
      y2 = this.getRightOperand().getFullyConverted().(AnalyzableExpr).maxValue() and
      result = (x1 * y1).minimum(x1 * y2).minimum(x2 * y1).minimum(x2 * y2)
    )
  }
}

class AddAnalyzableExpr extends AnalyzableExpr, AddExpr {
  override float maxValue() {
    result =
      this.getLeftOperand().getFullyConverted().(AnalyzableExpr).maxValue() +
        this.getRightOperand().getFullyConverted().(AnalyzableExpr).maxValue()
  }

  override float minValue() {
    result =
      this.getLeftOperand().getFullyConverted().(AnalyzableExpr).minValue() +
        this.getRightOperand().getFullyConverted().(AnalyzableExpr).minValue()
  }
}

class SubAnalyzableExpr extends AnalyzableExpr, SubExpr {
  override float maxValue() {
    result =
      this.getLeftOperand().getFullyConverted().(AnalyzableExpr).maxValue() -
        this.getRightOperand().getFullyConverted().(AnalyzableExpr).minValue()
  }

  override float minValue() {
    result =
      this.getLeftOperand().getFullyConverted().(AnalyzableExpr).minValue() -
        this.getRightOperand().getFullyConverted().(AnalyzableExpr).maxValue()
  }
}

class VarAnalyzableExpr extends AnalyzableExpr, VariableAccess {
  VarAnalyzableExpr() { this.getTarget() instanceof StackVariable }

  override float maxValue() {
    exists(SsaDefinition def, Variable v |
      def.getAUse(v) = this and
      // if there is a defining expression, use that for
      // computing the maximum value. Otherwise, assign the
      // variable the largest possible value it can hold
      if exists(def.getDefiningValue(v))
      then result = def.getDefiningValue(v).(AnalyzableExpr).maxValue()
      else result = upperBound(this)
    )
  }

  override float minValue() {
    exists(SsaDefinition def, Variable v |
      def.getAUse(v) = this and
      if exists(def.getDefiningValue(v))
      then result = def.getDefiningValue(v).(AnalyzableExpr).minValue()
      else result = lowerBound(this)
    )
  }
}

/**
 * Holds if `t` is not an instance of `IntegralType`,
 * or if `me` cannot be proven to not overflow
 */
pragma[inline]
predicate overflows(MulExpr me, Type t) {
  t instanceof IntegralType
  implies
  (
    me.(MulAnalyzableExpr).maxValue() > exprMaxVal(me)
    or
    me.(MulAnalyzableExpr).minValue() < exprMinVal(me)
  )
}

from MulExpr me, Type t1, Type t2
where
  t1 = me.getType().getUnderlyingType() and
  t2 = me.getConversion().getType().getUnderlyingType() and
  t1.getSize() < t2.getSize() and
  (
    t1.getUnspecifiedType() instanceof IntegralType and
    t2.getUnspecifiedType() instanceof IntegralType
    or
    t1.getUnspecifiedType() instanceof FloatingPointType and
    t2.getUnspecifiedType() instanceof FloatingPointType
  ) and
  // exclude explicit conversions
  me.getConversion().isCompilerGenerated() and
  // require the multiply to have two non-constant operands
  // (the intuition here is that multiplying two unknowns is
  // much more likely to produce a result that needs significantly
  // more bits than the operands did, and thus requires a larger
  // type).
  getEffectiveMulOperands(me) >= 2 and
  // exclude varargs promotions
  not exists(FunctionCall fc, int vararg |
    fc.getArgument(vararg) = me and
    vararg >= fc.getTarget().getNumberOfParameters()
  ) and
  // exclude cases where the type was made bigger by a literal
  // (compared to other cases such as assignment, this is more
  // likely to be a trivial accident rather than suggesting a
  // larger type is needed for the result).
  not exists(Expr other, Expr e |
    other = me.getParent().(BinaryOperation).getAnOperand() and
    not other = me and
    (
      e = other or
      e = other.(BinaryOperation).getAnOperand*()
    ) and
    e.(Literal).getType().getSize() = t2.getSize()
  ) and
  // only report if we cannot prove that the result of the
  // multiplication will be less (resp. greater) than the
  // maximum (resp. minimum) number we can compute.
  overflows(me, t1)
select me,
  "Multiplication result may overflow '" + me.getType().toString() + "' before it is converted to '"
    + me.getFullyConverted().getType().toString() + "'."
