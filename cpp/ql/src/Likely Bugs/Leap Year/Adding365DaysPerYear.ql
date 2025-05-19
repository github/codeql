/**
 * @name Arithmetic operation assumes 365 days per year
 * @description When an arithmetic operation modifies a date by a constant
 *              value of 365, it may be a sign that leap years are not taken
 *              into account.
 * @kind problem
 * @problem.severity error
 * @id cpp/microsoft/public/leap-year/adding-365-days-per-year
 * @precision medium
 * @tags leap-year
 *       correctness
 */

import cpp
import LeapYear
import semmle.code.cpp.dataflow.new.DataFlow

from Expr source, Expr sink
where
  PossibleYearArithmeticOperationCheckFlow::flow(DataFlow::exprNode(source),
    DataFlow::exprNode(sink))
select sink,
  "$@: This arithmetic operation $@ uses a constant value of 365 ends up modifying the date/time located at $@, without considering leap year scenarios.",
  sink.getEnclosingFunction(), sink.getEnclosingFunction().toString(), source, source.toString(),
  sink, sink.toString()
