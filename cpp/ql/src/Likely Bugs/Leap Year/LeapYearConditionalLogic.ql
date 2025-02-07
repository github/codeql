/**
 * @name Leap Year Conditional Logic (AntiPattern 7)
 * @description Conditional logic is present for leap years and common years, potentially leading to untested code pathways.
 * @kind problem
 * @problem.severity warning
 * @id cpp/microsoft/public/leap-year/conditional-logic-branches
 * @precision medium
 * @tags leap-year
 *       correctness
 */

import cpp
import LeapYear
import semmle.code.cpp.dataflow.new.DataFlow

class IfStmtLeapYearCheck extends IfStmt {
  IfStmtLeapYearCheck() {
    this.hasElse() and
    exists(ExprCheckLeapYear lyCheck, DataFlow::Node source, DataFlow::Node sink |
      source.asExpr() = lyCheck and
      sink.asExpr() = this.getCondition() and
      DataFlow::localFlow(source, sink)
    )
  }
}

from IfStmtLeapYearCheck lyCheckIf
select lyCheckIf, "Leap Year conditional statement may have untested code paths"
