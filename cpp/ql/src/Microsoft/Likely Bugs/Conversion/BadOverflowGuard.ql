/**
 * @name Bad overflow check
 * @description Checking for overflow of an addition by comparing against one
 *              of the arguments of the addition fails if the size of all the
 *              argument types are smaller than 4 bytes. This is because the
 *              result of the addition is promoted to a 4 byte int.
 * @kind problem
 * @problem.severity error
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 * @id cpp/microsoft/public/badoverflowguard
 */

import cpp

/*
 * Example:
 *
 * uint16 v, uint16 b
 * if ((v + b < v) <-- bad check for overflow
 */

from AddExpr a, Variable v, RelationalOperation cmp
where
  a.getAnOperand() = v.getAnAccess() and
  forall(Expr op | op = a.getAnOperand() | op.getType().getSize() < 4) and
  cmp.getAnOperand() = a and
  cmp.getAnOperand() = v.getAnAccess() and
  not a.getExplicitlyConverted().getType().getSize() < 4
select cmp, "Bad overflow check"
