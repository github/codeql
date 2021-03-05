/**
 * @name Self assignment
 * @description Assigning a variable to itself has no effect.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/redundant-assignment
 * @tags reliability
 *       correctness
 *       logic
 */

import java

from AssignExpr assign
where assign.getDest().(VarAccess).accessSameVarOfSameOwner(assign.getSource())
select assign,
  "This assigns the variable " + assign.getDest().(VarAccess).getVariable().getName() +
    " to itself and has no effect."
