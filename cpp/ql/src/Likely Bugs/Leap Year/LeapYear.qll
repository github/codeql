/**
 * Provides a library for helping create leap year related queries.
 */

import cpp
import semmle.code.cpp.dataflow.new.TaintTracking
import semmle.code.cpp.commons.DateTime

/**
 * Get the top-level `BinaryOperation` enclosing the expression e.
 */
private BinaryOperation getATopLevelBinaryOperationExpression(Expr e) {
  result = e.getEnclosingElement()
  or
  result = getATopLevelBinaryOperationExpression(e.getEnclosingElement())
}

/**
 * Holds if the top-level binary operation for expression `e` includes the operator specified in `operator` with an operand specified by `valueToCheck`.
 */
private predicate additionalLogicalCheck(Expr e, string operation, int valueToCheck) {
  exists(BinaryLogicalOperation bo | bo = getATopLevelBinaryOperationExpression(e) |
    exists(BinaryArithmeticOperation bao | bao = bo.getAChild*() |
      bao.getAnOperand().getValue().toInt() = valueToCheck and
      bao.getOperator() = operation
    )
  )
}

/**
 * An `Operation` that seems to be checking for leap year.
 */
class CheckForLeapYearOperation extends Expr {
  CheckForLeapYearOperation() {
    exists(BinaryArithmeticOperation bo | bo = this |
      bo.getAnOperand().getValue().toInt() = 4 and
      bo.getOperator() = "%" and
      additionalLogicalCheck(this.getEnclosingElement(), "%", 100) and
      additionalLogicalCheck(this.getEnclosingElement(), "%", 400)
    )
  }
}

bindingset[modVal]
Expr moduloCheckEQ_0(EQExpr eq, int modVal) {
  exists(RemExpr rem | rem = eq.getLeftOperand() |
    result = rem.getLeftOperand() and
    rem.getRightOperand().getValue().toInt() = modVal
  ) and
  eq.getRightOperand().getValue().toInt() = 0
}

bindingset[modVal]
Expr moduloCheckNEQ_0(NEExpr neq, int modVal) {
  exists(RemExpr rem | rem = neq.getLeftOperand() |
    result = rem.getLeftOperand() and
    rem.getRightOperand().getValue().toInt() = modVal
  ) and
  neq.getRightOperand().getValue().toInt() = 0
}

/**
 * Returns if the two expressions resolve to the same value, albeit it is a fuzzy attempt.
 * SSA is not fit for purpose here as calls break SSA equivalence.
 */
predicate exprEq_propertyPermissive(Expr e1, Expr e2) {
  not e1 = e2 and
  (
    DataFlow::localFlow(DataFlow::exprNode(e1), DataFlow::exprNode(e2))
    or
    if e1 instanceof ThisExpr and e2 instanceof ThisExpr
    then any()
    else
      /* If it's a direct Access, check that the target is the same. */
      if e1 instanceof Access
      then e1.(Access).getTarget() = e2.(Access).getTarget()
      else
        /* If it's a Call, compare qualifiers and only permit no-argument Calls. */
        if e1 instanceof Call
        then
          e1.(Call).getTarget() = e2.(Call).getTarget() and
          e1.(Call).getNumberOfArguments() = 0 and
          e2.(Call).getNumberOfArguments() = 0 and
          if e1.(Call).hasQualifier()
          then exprEq_propertyPermissive(e1.(Call).getQualifier(), e2.(Call).getQualifier())
          else any()
        else
          /* If it's a binaryOperation, compare op and recruse */
          if e1 instanceof BinaryOperation
          then
            e1.(BinaryOperation).getOperator() = e2.(BinaryOperation).getOperator() and
            exprEq_propertyPermissive(e1.(BinaryOperation).getLeftOperand(),
              e2.(BinaryOperation).getLeftOperand()) and
            exprEq_propertyPermissive(e1.(BinaryOperation).getRightOperand(),
              e2.(BinaryOperation).getRightOperand())
          else
            // Otherwise fail (and permit the raising of a finding)
            if e1 instanceof Literal
            then e1.(Literal).getValue() = e2.(Literal).getValue()
            else none()
  )
}

/**
 * An expression that is the subject of a mod-4 check.
 * ie `expr % 4 == 0`
 */
class Mod4CheckedExpr extends Expr {
  Mod4CheckedExpr() { exists(Expr e | e = moduloCheckEQ_0(this, 4)) }
}

/**
 * Year Div of 100 not equal to 0:
 * - `year % 100 != 0`
 * - `!(year % 100 == 0)`
 */
abstract class ExprCheckCenturyComponentDiv100 extends Expr {
  abstract Expr getYearExpr();
}

/**
 * The normal form of the expression `year % 100 != 0`.
 */
final class ExprCheckCenturyComponentDiv100Normative extends ExprCheckCenturyComponentDiv100 {
  ExprCheckCenturyComponentDiv100Normative() { exists(moduloCheckNEQ_0(this, 100)) }

  override Expr getYearExpr() { result = moduloCheckNEQ_0(this, 100) }
}

/**
 * The inverted form of the expression `year % 100 != 0`, ie `!(year % 100 == 0)`
 */
final class ExprCheckCenturyComponentDiv100Inverted extends ExprCheckCenturyComponentDiv100, NotExpr
{
  ExprCheckCenturyComponentDiv100Inverted() { exists(moduloCheckEQ_0(this.getOperand(), 100)) }

  override Expr getYearExpr() { result = moduloCheckEQ_0(this.getOperand(), 100) }
}

/**
 * A check that an expression is divisible by 400 or not
 * - `(year % 400 == 0)`
 * - `!(year % 400 != 0)`
 */
abstract class ExprCheckCenturyComponentDiv400 extends Expr {
  abstract Expr getYearExpr();
}

/**
 * The normative form of expression is divisible by 400:
 * ie `year % 400 == 0`
 */
final class ExprCheckCenturyComponentDiv400Normative extends ExprCheckCenturyComponentDiv400 {
  ExprCheckCenturyComponentDiv400Normative() { exists(moduloCheckEQ_0(this, 400)) }

  override Expr getYearExpr() {
    exists(Expr e |
      e = moduloCheckEQ_0(this, 400) and
      (
        if e instanceof ConvertedYearByOffset
        then result = e.(ConvertedYearByOffset).getYearOperand()
        else result = e
      )
    )
  }
}

/**
 * An arithmetic operation that seemingly converts an operand between time formats.
 */
class ConvertedYearByOffset extends BinaryArithmeticOperation {
  ConvertedYearByOffset() {
    this.getAnOperand().getValue().toInt() instanceof TimeFormatConversionOffset
  }

  Expr getYearOperand() {
    this.getLeftOperand().getValue().toInt() instanceof TimeFormatConversionOffset and
    result = this.getRightOperand()
    or
    this.getRightOperand().getValue().toInt() instanceof TimeFormatConversionOffset and
    result = this.getLeftOperand()
  }
}

/**
 * A flow configuration to track DataFlow from a `CovertedYearByOffset` to some `StructTmLeapYearFieldAccess`.
 */
module LocalConvertedYearByOffsetToLeapYearCheckFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { not n.asExpr() instanceof ConvertedYearByOffset }

  predicate isSink(DataFlow::Node n) { n.asExpr() instanceof StructTmLeapYearFieldAccess }
}

module LocalConvertedYearByOffsetToLeapYearCheckFlow =
  DataFlow::Global<LocalConvertedYearByOffsetToLeapYearCheckFlowConfig>;

/**
 * The set of ints (or strings) which represent a value that is typically used to convert between time data types.
 */
final class TimeFormatConversionOffset extends int {
  TimeFormatConversionOffset() {
    this =
      [
        1900, // tm_year represents years since 1900
        1970, // converting from/to Unix epoch
        2000, // some systems may use 2000 for 2-digit year conversions
      ]
  }
}

/**
 * The inverted form of expression is divisible by 400:
 * ie `!(year % 400 != 0)`
 */
final class ExprCheckCenturyComponentDiv400Inverted extends ExprCheckCenturyComponentDiv400, NotExpr
{
  ExprCheckCenturyComponentDiv400Inverted() { exists(moduloCheckNEQ_0(this.getOperand(), 400)) }

  override Expr getYearExpr() { result = moduloCheckNEQ_0(this.getOperand(), 400) }
}

/**
 * The Century component of a Leap-Year guard
 */
class ExprCheckCenturyComponent extends LogicalOrExpr {
  ExprCheckCenturyComponent() {
    exists(ExprCheckCenturyComponentDiv400 exprDiv400, ExprCheckCenturyComponentDiv100 exprDiv100 |
      this.getAnOperand() = exprDiv100 and
      this.getAnOperand() = exprDiv400 and
      exprEq_propertyPermissive(exprDiv100.getYearExpr(), exprDiv400.getYearExpr())
    )
  }

  Expr getYearExpr() {
    exists(ExprCheckCenturyComponentDiv400 exprDiv400 |
      this.getAnOperand() = exprDiv400 and
      result = exprDiv400.getYearExpr()
    )
  }
}

/**
 * A **Valid** Leap year check expression.
 */
abstract class ExprCheckLeapYear extends Expr { }

/**
 * A valid Leap-Year guard expression of the following form:
 *  `dt.Year % 4 == 0 && (dt.Year % 100 != 0 || dt.Year % 400 == 0)`
 */
final class ExprCheckLeapYearFormA extends ExprCheckLeapYear, LogicalAndExpr {
  ExprCheckLeapYearFormA() {
    exists(Expr e, ExprCheckCenturyComponent centuryCheck |
      e = moduloCheckEQ_0(this.getLeftOperand(), 4) and
      centuryCheck = this.getAnOperand().getAChild*() and
      exprEq_propertyPermissive(e, centuryCheck.getYearExpr())
    )
  }
}

/**
 * A valid Leap-Year guard expression of the following forms:
 *  `year % 400 == 0 || (year % 100 != 0 && year % 4 == 0)`
 *  `(year + 1900) % 400 == 0 || (year % 100 != 0 && year % 4 == 0)`
 */
final class ExprCheckLeapYearFormB extends ExprCheckLeapYear, LogicalOrExpr {
  ExprCheckLeapYearFormB() {
    exists(VariableAccess va1, VariableAccess va2, VariableAccess va3 |
      va1 = moduloCheckEQ_0(this.getAnOperand(), 400) and
      va2 = moduloCheckNEQ_0(this.getAnOperand().(LogicalAndExpr).getAnOperand(), 100) and
      va3 = moduloCheckEQ_0(this.getAnOperand().(LogicalAndExpr).getAnOperand(), 4) and
      // The 400-leap year check may be offset by [1900,1970,2000].
      exists(Expr va1_subExpr | va1_subExpr = va1.getAChild*() |
        exprEq_propertyPermissive(va1_subExpr, va2) and
        exprEq_propertyPermissive(va2, va3)
      )
    )
  }
}

Expr leapYearOpEnclosingElement(CheckForLeapYearOperation op) { result = op.getEnclosingElement() }

/**
 * A value that resolves as a constant integer that represents some normalization or conversion between date types.
 */
pragma[inline]
private predicate isNormalizationPrimitiveValue(Expr e) {
  e.getValue().toInt() = [1900, 2000, 1980, 80]
}

/**
 * A normalization operation is an expression that is merely attempting to convert between two different datetime schemes,
 * and does not apply any additional mutation to the represented value.
 */
pragma[inline]
predicate isNormalizationOperation(Expr e) {
  isNormalizationPrimitiveValue([e, e.(Operation).getAChild()])
  or
  // Special case for transforming marshaled 2-digit year date:
  // theTime.wYear += 100*value;
  e.(Operation).getAChild().(MulExpr).getValue().toInt() = 100
}

/**
 * Get the field accesses used in a `ExprCheckLeapYear` expression.
 */
LeapYearFieldAccess leapYearCheckFieldAccess(ExprCheckLeapYear a) { result = a.getAChild*() }

/**
 * A `YearFieldAccess` that would represent an access to a year field on a struct and is used for arguing about leap year calculations.
 */
abstract class LeapYearFieldAccess extends YearFieldAccess {
  /**
   * Holds if the field access is a modification,
   * and it involves an arithmetic operation.
   */
  predicate isModifiedByArithmeticOperation() {
    this.isModified() and
    exists(Operation op |
      op.getAnOperand() = this and
      (
        op instanceof AssignArithmeticOperation or
        op.getAnOperand() instanceof BinaryArithmeticOperation or
        op instanceof CrementOperation
      )
    )
  }

  /**
   * Holds if the field access is a modification,
   * and it involves an arithmetic operation.
   * In order to avoid false positives, the operation does not includes values that are normal for year normalization.
   *
   * 1900 - `struct tm` counts years since 1900
   * 1980/80 - FAT32 epoch
   */
  predicate isModifiedByArithmeticOperationNotForNormalization() {
    this.isModified() and
    exists(Operation op |
      op.getAnOperand() = this and
      not isNormalizationOperation(op)
    )
  }

  /**
   * Holds if the top-level binary operation includes a modulus operator with an operand specified by `valueToCheck`.
   */
  predicate additionalModulusCheckForLeapYear(int valueToCheck) {
    additionalLogicalCheck(this, "%", valueToCheck)
  }

  /**
   * Holds if the top-level binary operation includes an addition or subtraction operator with an operand specified by `valueToCheck`.
   */
  predicate additionalAdditionOrSubstractionCheckForLeapYear(int valueToCheck) {
    additionalLogicalCheck(this, "+", valueToCheck) or
    additionalLogicalCheck(this, "-", valueToCheck)
  }

  /**
   * Holds if this object is used on a modulus 4 operation, which would likely indicate the start of a leap year check.
   */
  predicate isUsedInMod4Operation() {
    not this.isModified() and
    exists(BinaryArithmeticOperation bo |
      bo.getAnOperand() = this and
      bo.getAnOperand().getValue().toInt() = 4 and
      bo.getOperator() = "%"
    )
  }

  /**
   * Holds if this object seems to be used in a valid gregorian calendar leap year check.
   */
  predicate isUsedInCorrectLeapYearCheck() {
    // The Gregorian leap year rule is:
    // Every year that is exactly divisible by four is a leap year,
    // except for years that are exactly divisible by 100,
    // but these centurial years are leap years if they are exactly divisible by 400
    //
    // https://aa.usno.navy.mil/faq/docs/calendars.php
    this = leapYearCheckFieldAccess(_)
  }
}

/**
 * `YearFieldAccess` for the `SYSTEMTIME` struct.
 */
class StructSystemTimeLeapYearFieldAccess extends LeapYearFieldAccess {
  StructSystemTimeLeapYearFieldAccess() { this.getTarget().getName() = "wYear" }
}

/**
 * `YearFieldAccess` for `struct tm`.
 */
class StructTmLeapYearFieldAccess extends LeapYearFieldAccess {
  StructTmLeapYearFieldAccess() { this.getTarget().getName() = "tm_year" }

  override predicate isUsedInCorrectLeapYearCheck() {
    this = leapYearCheckFieldAccess(_) and
    /* There is some data flow from some conversion arithmetic to this expression. */
    LocalConvertedYearByOffsetToLeapYearCheckFlow::flow(_, DataFlow::exprNode(this))
  }
}

/**
 * `Function` that includes an operation that is checking for leap year.
 */
class ChecksForLeapYearFunction extends Function {
  ChecksForLeapYearFunction() { this = any(CheckForLeapYearOperation clyo).getEnclosingFunction() }
}

/**
 * `FunctionCall` that includes an operation that is checking for leap year.
 */
class ChecksForLeapYearFunctionCall extends FunctionCall {
  ChecksForLeapYearFunctionCall() { this.getTarget() instanceof ChecksForLeapYearFunction }
}

/**
 * A `DataFlow` configuraiton for finding a variable access that would flow into
 * a function call that includes an operation to check for leap year.
 */
private module LeapYearCheckFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof VariableAccess }

  predicate isSink(DataFlow::Node sink) {
    exists(ChecksForLeapYearFunctionCall fc | sink.asExpr() = fc.getAnArgument())
  }
}

module LeapYearCheckFlow = DataFlow::Global<LeapYearCheckFlowConfig>;

/**
 * A `DataFlow` configuration for finding an operation with hardcoded 365 that will flow into a `_FILETIME` field.
 */
private module FiletimeYearArithmeticOperationCheckConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(Expr e, Operation op | e = source.asExpr() |
      op.getAChild*().getValue().toInt() = 365 and
      op.getAChild*() = e
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(StructLikeClass dds, FieldAccess fa, AssignExpr aexpr, Expr e | e = sink.asExpr() |
      dds instanceof PackedTimeType and
      fa.getQualifier().getUnderlyingType() = dds and
      fa.isModified() and
      aexpr.getAChild() = fa and
      aexpr.getChild(1).getAChild*() = e
    )
  }
}

module FiletimeYearArithmeticOperationCheckFlow =
  DataFlow::Global<FiletimeYearArithmeticOperationCheckConfig>;

/**
 * A `DataFlow` configuration for finding an operation with hardcoded 365 that will flow into any known date/time field.
 */
private module PossibleYearArithmeticOperationCheckConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // NOTE: addressing current issue with new IR dataflow, where
    // constant folding occurs before dataflow nodes are associated
    // with the constituent literals.
    source.asExpr().getAChild*().getValue().toInt() = 365 and
    not exists(DataFlow::Node parent | parent.asExpr().getAChild+() = source.asExpr())
  }

  predicate isSink(DataFlow::Node sink) {
    exists(StructLikeClass dds, FieldAccess fa, AssignExpr aexpr |
      (dds instanceof PackedTimeType or dds instanceof UnpackedTimeType) and
      fa.getQualifier().getUnderlyingType() = dds and
      fa.isModified() and
      aexpr.getLValue() = fa and
      sink.asExpr() = aexpr.getRValue()
    )
  }
}

module PossibleYearArithmeticOperationCheckFlow =
  TaintTracking::Global<PossibleYearArithmeticOperationCheckConfig>;

/**
 * A `YearFieldAccess` that is modifying the year by any arithmetic operation.
 *
 * NOTE:
 * To change this class to work for general purpose date transformations that do not check the return value,
 * make the following changes:
 *  - change `extends LeapYearFieldAccess` to `extends FieldAccess`.
 *  - change `this.isModifiedByArithmeticOperation()` to `this.isModified()`.
 * Expect a lower precision for a general purpose version.
 */
class DateStructModifiedFieldAccess extends LeapYearFieldAccess {
  DateStructModifiedFieldAccess() {
    exists(Field f, StructLikeClass struct |
      f.getAnAccess() = this and
      struct.getAField() = f and
      struct.getUnderlyingType() instanceof UnpackedTimeType and
      this.isModifiedByArithmeticOperation()
    )
  }
}

/**
 * This is a list of APIs that will get the system time, and therefore guarantee that the value is valid.
 */
class SafeTimeGatheringFunction extends Function {
  SafeTimeGatheringFunction() {
    this.getQualifiedName() = ["GetFileTime", "GetSystemTime", "NtQuerySystemTime"]
  }
}

/**
 * This list of APIs should check for the return value to detect problems during the conversion.
 */
class TimeConversionFunction extends Function {
  TimeConversionFunction() {
    this.getQualifiedName() =
      [
        "FileTimeToSystemTime", "SystemTimeToFileTime", "SystemTimeToTzSpecificLocalTime",
        "SystemTimeToTzSpecificLocalTimeEx", "TzSpecificLocalTimeToSystemTime",
        "TzSpecificLocalTimeToSystemTimeEx", "RtlLocalTimeToSystemTime",
        "RtlTimeToSecondsSince1970", "_mkgmtime"
      ]
  }
}
