/**
 * @name Trace branches in JVM methods
 * @description Lists all conditional and unconditional branches
 * @kind table
 * @id jvm/trace-branches
 */

import semmle.code.binary.ast.internal.JvmInstructions

from JvmBranch branch
select branch.getEnclosingMethod().getFullyQualifiedName() as method, branch.getOffset() as offset,
  branch.getMnemonic() as branchType, branch.getBranchTarget() as targetOffset
