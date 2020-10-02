/**
 * @name Unchecked return value for time conversion function
 * @description When the return value of a fallible time conversion function is
 *              not checked for failure, its output parameters may contain
 *              invalid dates.
 * @kind problem
 * @problem.severity warning
 * @id cpp/leap-year/unchecked-return-value-for-time-conversion-function
 * @precision medium
 * @tags leap-year
 *       correctness
 */

import cpp
import LeapYear

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
      ["FileTimeToSystemTime", "SystemTimeToFileTime", "SystemTimeToTzSpecificLocalTime",
          "SystemTimeToTzSpecificLocalTimeEx", "TzSpecificLocalTimeToSystemTime",
          "TzSpecificLocalTimeToSystemTimeEx", "RtlLocalTimeToSystemTime",
          "RtlTimeToSecondsSince1970", "_mkgmtime"]
  }
}

from FunctionCall fcall, TimeConversionFunction trf, Variable var
where
  fcall = trf.getACallToThisFunction() and
  fcall instanceof ExprInVoidContext and
  var.getUnderlyingType() instanceof UnpackedTimeType and
  (
    exists(AddressOfExpr aoe |
      aoe = fcall.getAnArgument() and
      aoe.getAddressable() = var
    )
    or
    exists(VariableAccess va |
      fcall.getAnArgument() = va and
      var.getAnAccess() = va
    )
  ) and
  exists(DateStructModifiedFieldAccess dsmfa, VariableAccess modifiedVarAccess |
    modifiedVarAccess = var.getAnAccess() and
    modifiedVarAccess = dsmfa.getQualifier() and
    modifiedVarAccess = fcall.getAPredecessor*()
  ) and
  // Remove false positives
  not (
    // Remove any instance where the predecessor is a SafeTimeGatheringFunction and no change to the data happened in between
    exists(FunctionCall pred |
      pred = fcall.getAPredecessor*() and
      exists(SafeTimeGatheringFunction stgf | pred = stgf.getACallToThisFunction()) and
      not exists(DateStructModifiedFieldAccess dsmfa, VariableAccess modifiedVarAccess |
        modifiedVarAccess = var.getAnAccess() and
        modifiedVarAccess = dsmfa.getQualifier() and
        modifiedVarAccess = fcall.getAPredecessor*() and
        modifiedVarAccess = pred.getASuccessor*()
      )
    )
    or
    // Remove any instance where the year is changed, but the month is set to 1 (year wrapping)
    exists(MonthFieldAccess mfa, AssignExpr ae |
      mfa.getQualifier() = var.getAnAccess() and
      mfa.isModified() and
      mfa = fcall.getAPredecessor*() and
      ae = mfa.getEnclosingElement() and
      ae.getAnOperand().getValue().toInt() = 1
    )
  )
select fcall,
  "Return value of $@ function should be verified to check for any error because variable $@ is not guaranteed to be safe.",
  trf, trf.getQualifiedName().toString(), var, var.getName()
