/**
 * @name Duplicate 'if' branches
 * @description If the 'then' and 'else' branches of an 'if' statement are identical, the
 *              conditional may be superfluous, or it may indicate a mistake.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id go/duplicate-branches
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-561
 */

import Clones

class HashedBranch extends HashRoot, Stmt {
  HashedBranch() { exists(IfStmt is | this = is.getThen() or this = is.getElse()) }
}

from IfStmt is, HashableNode thenBranch, HashableNode elseBranch
where
  thenBranch = is.getThen() and
  elseBranch = is.getElse() and
  thenBranch.hash() = elseBranch.hash()
select is.getCond(), "The 'then' and 'else' branches of this if statement are identical."
