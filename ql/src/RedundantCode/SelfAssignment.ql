/**
 * @name Self assignment
 * @description Assigning a variable to itself has no effect.
 * @kind problem
 * @problem.severity warning
 * @id go/redundant-assignment
 * @tags correctness
 *       external/cwe/cwe-480
 *       external/cwe/cwe-561
 * @precision high
 */

import Clones

/**
 * An assignment that may be a self assignment.
 */
class PotentialSelfAssignment extends HashRoot, AssignStmt {
  PotentialSelfAssignment() { getLhs().getKind() = getRhs().getKind() }
}

from PotentialSelfAssignment assgn, HashableNode rhs
where
  rhs = assgn.getRhs() and
  rhs.hash() = assgn.getLhs().(HashableNode).hash()
select assgn, "This statement assigns $@ to itself.", rhs, "an expression"
