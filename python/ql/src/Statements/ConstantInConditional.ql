/**
 * @name Constant in conditional expression or statement
 * @description The conditional is always true or always false
 * @kind problem
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 *       external/cwe/cwe-570
 *       external/cwe/cwe-571
 * @problem.severity warning
 * @sub-severity low
 * @precision very-high
 * @id py/constant-conditional-expression
 */

import python

predicate is_condition(Expr cond) {
  exists(If i | i.getTest() = cond) or
  exists(IfExp ie | ie.getTest() = cond)
}

/* Treat certain unmodified builtins as constants as well. */
predicate effective_constant(Name cond) {
  exists(GlobalVariable var | var = cond.getVariable() and not exists(NameNode f | f.defines(var)) |
    var.getId() = "True" or var.getId() = "False" or var.getId() = "NotImplemented"
  )
}

predicate test_makes_code_unreachable(Expr cond) {
  exists(If i | i.getTest() = cond | i.getStmt(0).isUnreachable() or i.getOrelse(0).isUnreachable())
  or
  exists(While w | w.getTest() = cond and w.getStmt(0).isUnreachable())
}

from Expr cond
where
  is_condition(cond) and
  (cond.isConstant() or effective_constant(cond)) and
  /* Ignore cases where test makes code unreachable, as that is handled in different query */
  not test_makes_code_unreachable(cond)
select cond, "Testing a constant will always give the same result."
