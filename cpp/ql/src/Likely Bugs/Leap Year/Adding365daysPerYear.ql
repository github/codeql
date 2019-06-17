/**
 * @name Year field changed using an arithmetic operation is used on an unchecked time conversion function
 * @description A year field changed using an arithmetic operation is used on a time conversion function, but the return value of the function is not checked for success or failure.
 * @kind problem
 * @problem.severity error
 * @id cpp/leap-year/adding-365-days-per-year
 * @precision high
 * @tags security
 *       leap-year
 */

import cpp
import LeapYear
import semmle.code.cpp.dataflow.DataFlow

from Expr source, Expr sink, PossibleYearArithmeticOperationCheckConfiguration config
where config.hasFlow(DataFlow::exprNode(source), DataFlow::exprNode(sink))
select sink,
  "This arithmetic operation $@ uses a constant value of 365 ends up modifying the date/time located at $@, without considering leap year scenarios.",
  source, source.toString(), sink, sink.toString()
