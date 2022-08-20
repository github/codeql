/**
 * @name Expression can be replaced with a cast
 * @description An exists/any that is only used to cast a value to a type
 *              can be replaced with a cast.
 * @kind problem
 * @problem.severity warning
 * @id ql/could-be-cast
 * @precision very-high
 */

import ql
import codeql_ql.style.CouldBeCastQuery

from AstNode aggr, VarDecl var, string msg, Expr operand
where
  exists(string kind | aggregateCouldBeCast(aggr, _, kind, var, operand) |
    kind = "exists" and
    if operand.getType().getASuperType*() = var.getType()
    then msg = "The assignment in the exists(..) is redundant."
    else msg = "The assignment to $@ in the exists(..) can replaced with an instanceof expression."
    or
    kind = "any" and
    if operand.getType().getASuperType*() = var.getType()
    then msg = "The assignment in the any(..) is redundant."
    else msg = "The assignment to $@ in this any(..) can be replaced with an inline cast."
  )
select aggr, msg, var, var.getName()
