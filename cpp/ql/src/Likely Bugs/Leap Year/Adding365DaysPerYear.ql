/**
 * @name Arithmetic operation assumes 365 days per year
 * @description When an arithmetic operation modifies a date by a constant
 *              value of 365, it may be a sign that leap years are not taken
 *              into account.
 * @kind problem
 * @problem.severity warning
 * @id cpp/leap-year/adding-365-days-per-year
 * @precision medium
 * @tags leap-year
 *       correctness
 */

import cpp
import LeapYear

from Expr source, Expr sink
where
  PossibleYearArithmeticOperationCheckFlow::flow(DataFlow::exprNode(source),
    DataFlow::exprNode(sink))
select sink,
  "An arithmetic operation $@ that uses a constant value of 365 ends up modifying this date/time, without considering leap year scenarios.",
  source, source.toString()
