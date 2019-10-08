/**
 * Provides a library for helping create leap year related queries.
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.commons.DateTime

/**
 * Get the top-level `BinaryOperation` enclosing the expression e.
 */
private BinaryOperation getATopLevelBinaryOperationExpression(Expr e) {
  result = e.getEnclosingElement().(BinaryOperation)
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
        exists(BinaryArithmeticOperation bao | bao = op.getAnOperand()) or
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
      (
        op instanceof AssignArithmeticOperation and
        not (
          op.getAChild().getValue().toInt() = 1900
          or
          op.getAChild().getValue().toInt() = 2000
          or
          op.getAChild().getValue().toInt() = 1980
          or
          op.getAChild().getValue().toInt() = 80
          or
          // Special case for transforming marshaled 2-digit year date:
          // theTime.wYear += 100*value;
          exists(MulExpr mulBy100 | mulBy100 = op.getAChild() |
            mulBy100.getAChild().getValue().toInt() = 100
          )
        )
        or
        exists(BinaryArithmeticOperation bao |
          bao = op.getAnOperand() and
          // we're specifically interested in calculations that update the existing
          // value (like `x = x + 1`), so look for a child `YearFieldAccess`.
          bao.getAChild*() instanceof YearFieldAccess and
          not (
            bao.getAChild().getValue().toInt() = 1900
            or
            bao.getAChild().getValue().toInt() = 2000
            or
            bao.getAChild().getValue().toInt() = 1980
            or
            bao.getAChild().getValue().toInt() = 80
            or
            // Special case for transforming marshaled 2-digit year date:
            // theTime.wYear += 100*value;
            exists(MulExpr mulBy100 | mulBy100 = op.getAChild() |
              mulBy100.getAChild().getValue().toInt() = 100
            )
          )
        )
        or
        op instanceof CrementOperation
      )
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
    this.isUsedInMod4Operation() and
    additionalModulusCheckForLeapYear(400) and
    additionalModulusCheckForLeapYear(100)
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
    this.isUsedInMod4Operation() and
    additionalModulusCheckForLeapYear(400) and
    additionalModulusCheckForLeapYear(100) and
    // tm_year represents years since 1900
    (
      additionalAdditionOrSubstractionCheckForLeapYear(1900)
      or
      // some systems may use 2000 for 2-digit year conversions
      additionalAdditionOrSubstractionCheckForLeapYear(2000)
      or
      // converting from/to Unix epoch
      additionalAdditionOrSubstractionCheckForLeapYear(1970)
    )
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
 * `DataFlow::Configuration` for finding a variable access that would flow into
 * a function call that includes an operation to check for leap year.
 */
class LeapYearCheckConfiguration extends DataFlow::Configuration {
  LeapYearCheckConfiguration() { this = "LeapYearCheckConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(VariableAccess va | va = source.asExpr())
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ChecksForLeapYearFunctionCall fc | sink.asExpr() = fc.getAnArgument())
  }
}

/**
 * `DataFlow::Configuration` for finding an operation with hardcoded 365 that will flow into a `FILEINFO` field.
 */
class FiletimeYearArithmeticOperationCheckConfiguration extends DataFlow::Configuration {
  FiletimeYearArithmeticOperationCheckConfiguration() {
    this = "FiletimeYearArithmeticOperationCheckConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    exists(Expr e, Operation op | e = source.asExpr() |
      op.getAChild*().getValue().toInt() = 365 and
      op.getAChild*() = e
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(StructLikeClass dds, FieldAccess fa, AssignExpr aexpr, Expr e | e = sink.asExpr() |
      dds instanceof PackedTimeType and
      fa.getQualifier().getUnderlyingType() = dds and
      fa.isModified() and
      aexpr.getAChild() = fa and
      aexpr.getChild(1).getAChild*() = e
    )
  }
}

/**
 * `DataFlow::Configuration` for finding an operation with hardcoded 365 that will flow into any known date/time field.
 */
class PossibleYearArithmeticOperationCheckConfiguration extends DataFlow::Configuration {
  PossibleYearArithmeticOperationCheckConfiguration() {
    this = "PossibleYearArithmeticOperationCheckConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    exists(Operation op | op = source.asExpr() |
      op.getAChild*().getValue().toInt() = 365 and
      not op.getParent() instanceof Expr
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // flow from anything on the RHS of an assignment to a time/date structure to that
    // assignment.
    exists(StructLikeClass dds, FieldAccess fa, AssignExpr aexpr, Expr e |
      e = node1.asExpr() and
      aexpr = node2.asExpr()
    |
      (dds instanceof PackedTimeType or dds instanceof UnpackedTimeType) and
      fa.getQualifier().getUnderlyingType() = dds and
      aexpr.getLValue() = fa and
      aexpr.getRValue().getAChild*() = e
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(StructLikeClass dds, FieldAccess fa, AssignExpr aexpr | aexpr = sink.asExpr() |
      (dds instanceof PackedTimeType or dds instanceof UnpackedTimeType) and
      fa.getQualifier().getUnderlyingType() = dds and
      fa.isModified() and
      aexpr.getLValue() = fa
    )
  }
}
