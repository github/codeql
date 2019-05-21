/**
 * @name Year field changed using an arithmetic operation without checking for leap year
 * @description A that field that represents a year is being modified by an arithmetic operation, but no proper check for leap year can be detected afterwards.
 * @kind problem
 * @problem.severity error
 * @id cpp/leap-year/unchecked-after-arithmetic-year-modification
 * @precision high
 * @tags security
 *       leap-year
 */

import cpp
import LeapYear

from Variable var, LeapYearFieldAccess yfa 
where
    exists( VariableAccess va |
    yfa.getQualifier() = va
        and var.getAnAccess() = va
        // The year is modified with an arithmetic operation. Avoid values that are likely false positives
        and yfa.isModifiedByArithmeticOperationNotForNormalization()
        // Avoid false positives
        and not (
            // If there is a local check for leap year after the modification
            exists( LeapYearFieldAccess yfacheck |
                yfacheck.getQualifier() = var.getAnAccess()
                and yfacheck.isUsedInCorrectLeapYearCheck()
                and yfacheck = yfa.getASuccessor*()
            )
            // If there is a data flow from the variable that was modified to a function that seems to check for leap year 
            or exists(
                VariableAccess source,
                ChecksForLeapYearFunctionCall fc, 
                LeapYearCheckConfiguration config |
                source = var.getAnAccess()
                and config.hasFlow( DataFlow::exprNode(source), DataFlow::exprNode(fc.getAnArgument()))
            )
            // If there is a data flow from the field that was modified to a function that seems to check for leap year
            or exists(
                VariableAccess vacheck,
                YearFieldAccess yfacheck,
                ChecksForLeapYearFunctionCall fc, 
                LeapYearCheckConfiguration config |
                vacheck = var.getAnAccess()
                and yfacheck.getQualifier() = vacheck
                and config.hasFlow( DataFlow::exprNode(yfacheck), DataFlow::exprNode(fc.getAnArgument()))
            )
            // If there is a successor or predecessor that sets the month = 1
            or exists( 
                MonthFieldAccess  mfa, AssignExpr ae |
                    mfa.getQualifier() = var.getAnAccess()
                    and mfa.isModified()
                    and ( mfa = yfa.getASuccessor*()
                          or yfa = mfa.getASuccessor*())
                    and ae = mfa.getEnclosingElement()
                    and ae.getAnOperand().getValue().toInt() = 1 
            )
        )
    )
select yfa
  , "Field $@ on variable $@ has been modified, but no appropriate check for LeapYear was found.", yfa.getTarget(), yfa.getTarget().toString(), var, var.toString()
