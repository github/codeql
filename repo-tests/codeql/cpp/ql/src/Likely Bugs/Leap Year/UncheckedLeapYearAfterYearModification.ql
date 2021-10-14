/**
 * @name Year field changed using an arithmetic operation without checking for leap year
 * @description A field that represents a year is being modified by an arithmetic operation, but no proper check for leap years can be detected afterwards.
 * @kind problem
 * @problem.severity warning
 * @id cpp/leap-year/unchecked-after-arithmetic-year-modification
 * @precision medium
 * @tags leap-year
 *       correctness
 */

import cpp
import LeapYear

from Variable var, LeapYearFieldAccess yfa
where
  exists(VariableAccess va |
    yfa.getQualifier() = va and
    var.getAnAccess() = va and
    // The year is modified with an arithmetic operation. Avoid values that are likely false positives
    yfa.isModifiedByArithmeticOperationNotForNormalization() and
    // Avoid false positives
    not (
      // If there is a local check for leap year after the modification
      exists(LeapYearFieldAccess yfacheck |
        yfacheck.getQualifier() = var.getAnAccess() and
        yfacheck.isUsedInCorrectLeapYearCheck() and
        yfacheck.getBasicBlock() = yfa.getBasicBlock().getASuccessor*()
      )
      or
      // If there is a data flow from the variable that was modified to a function that seems to check for leap year
      exists(
        VariableAccess source, ChecksForLeapYearFunctionCall fc, LeapYearCheckConfiguration config
      |
        source = var.getAnAccess() and
        config.hasFlow(DataFlow::exprNode(source), DataFlow::exprNode(fc.getAnArgument()))
      )
      or
      // If there is a data flow from the field that was modified to a function that seems to check for leap year
      exists(
        VariableAccess vacheck, YearFieldAccess yfacheck, ChecksForLeapYearFunctionCall fc,
        LeapYearCheckConfiguration config
      |
        vacheck = var.getAnAccess() and
        yfacheck.getQualifier() = vacheck and
        config.hasFlow(DataFlow::exprNode(yfacheck), DataFlow::exprNode(fc.getAnArgument()))
      )
      or
      // If there is a successor or predecessor that sets the month = 1
      exists(MonthFieldAccess mfa, AssignExpr ae |
        mfa.getQualifier() = var.getAnAccess() and
        mfa.isModified() and
        (
          mfa.getBasicBlock() = yfa.getBasicBlock().getASuccessor*() or
          yfa.getBasicBlock() = mfa.getBasicBlock().getASuccessor+()
        ) and
        ae = mfa.getEnclosingElement() and
        ae.getAnOperand().getValue().toInt() = 1
      )
    )
  )
select yfa,
  "Field $@ on variable $@ has been modified, but no appropriate check for LeapYear was found.",
  yfa.getTarget(), yfa.getTarget().toString(), var, var.toString()
