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

Expr moduloCheckEQ_0(EQExpr eq, int modVal) {
  exists(RemExpr rem | rem = eq.getLeftOperand() |
    result = rem.getLeftOperand() and
    rem.getRightOperand().getValue().toInt() = modVal
  ) and
  eq.getRightOperand().getValue().toInt() = 0
}

Expr moduloCheckNEQ_0(NEExpr neq, int modVal) {
  exists(RemExpr rem | rem = neq.getLeftOperand() |
    result = rem.getLeftOperand() and
    rem.getRightOperand().getValue().toInt() = modVal
  ) and
  neq.getRightOperand().getValue().toInt() = 0
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
    this.getAnOperand() instanceof ExprCheckCenturyComponentDiv100 and
    this.getAnOperand() instanceof ExprCheckCenturyComponentDiv400
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
    exists(ExprCheckCenturyComponent centuryCheck |
      exists(moduloCheckEQ_0(this.getLeftOperand(), 4)) and
      centuryCheck = this.getAnOperand().getAChild*()
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
    exists(LogicalAndExpr land |
      exists(moduloCheckEQ_0(this.getAnOperand(), 400)) and
      land = this.getAnOperand() and
      exists(moduloCheckNEQ_0(land.getAnOperand(), 100)) and
      exists(moduloCheckEQ_0(land.getAnOperand(), 4))
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
  predicate additionalAdditionOrSubtractionCheckForLeapYear(int valueToCheck) {
    additionalLogicalCheck(this, "+", valueToCheck) or
    additionalLogicalCheck(this, "-", valueToCheck)
  }

  /**
   * DEPRECATED: Use `additionalAdditionOrSubtractionCheckForLeapYear` instead.
   */
  deprecated predicate additionalAdditionOrSubstractionCheckForLeapYear(int valueToCheck) {
    this.additionalAdditionOrSubtractionCheckForLeapYear(valueToCheck)
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
 * `stDate.wMonth == 2`
 */
private class DateCheckMonthFebruary extends EQExpr {
  MonthFieldAccess mfa;
  
  DateCheckMonthFebruary() {
    this.hasOperands(mfa, any(Literal lit | lit.getValue() = "2"))
  }

  Expr getDateQualifier() { result = mfa.getQualifier() }
}

/**
 * `stDate.wDay == 29`
 */
class DateCheckDay29 extends EQExpr {
  DayFieldAccess dfa;

  DateCheckDay29() { this.hasOperands(dfa, any(Literal lit | lit.getValue() = "29")) }

  Expr getDateQualifier() { result = dfa.getQualifier() }
}

/**
 * The combination of a February and Day 29 verification
 * `stDate.wMonth == 2 && stDate.wDay == 29`
 */
class DateFebruary29Check extends LogicalAndExpr {
  DateCheckMonthFebruary checkFeb;

  DateFebruary29Check() { this.hasOperands(checkFeb, any(DateCheckDay29 check29)) }

  Expr getDateQualifier() { result = checkFeb.getDateQualifier() }
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
 * A `DataFlow` configuration for finding a variable access that would flow into
 * a function call that includes an operation to check for leap year.
 */
private module LeapYearCheckFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof VariableAccess }

  predicate isSink(DataFlow::Node sink) {
    exists(ChecksForLeapYearFunctionCall fc | sink.asExpr() = fc.getAnArgument())
  }

  predicate observeDiffInformedIncrementalMode() {
    none() // only used negatively in UncheckedLeapYearAfterYearModification.ql
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

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    result = source.asExpr().getLocation()
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) { result = sink.asExpr().getLocation() }
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
 * A time conversion function where either
 * 1) an incorrect leap year date would result in an error that can be checked from the return value or
 * 2) an incorrect leap year date is auto corrected (no checks required)
 */
class TimeConversionFunction extends Function {
  boolean autoLeapYearCorrecting;

  TimeConversionFunction() {
    autoLeapYearCorrecting = false and
    (
      this.getName() =
        [
          "FileTimeToSystemTime", "SystemTimeToFileTime", "SystemTimeToTzSpecificLocalTime",
          "SystemTimeToTzSpecificLocalTimeEx", "TzSpecificLocalTimeToSystemTime",
          "TzSpecificLocalTimeToSystemTimeEx", "RtlLocalTimeToSystemTime",
          "RtlTimeToSecondsSince1970", "_mkgmtime", "SetSystemTime", "VarUdateFromDate", "from_tm"
        ]
      or
      // Matches all forms of GetDateFormat, e.g. GetDateFormatA/W/Ex
      this.getName().matches("GetDateFormat%")
    )
    or
    autoLeapYearCorrecting = true and
    this.getName() =
      ["mktime", "_mktime32", "_mktime64", "SystemTimeToVariantTime", "VariantTimeToSystemTime"]
  }

  /**
   * Holds if the function is expected to auto convert a bad leap year date.
   */
  predicate isAutoLeapYearCorrecting() { autoLeapYearCorrecting = true }
}
