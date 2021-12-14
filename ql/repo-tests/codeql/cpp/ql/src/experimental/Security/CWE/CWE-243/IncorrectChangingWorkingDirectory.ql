/**
 * @name Find work with changing working directories, with security errors.
 * @description Not validating the return value or pinning the directory can be unsafe.
 * @kind problem
 * @id cpp/work-with-changing-working-directories
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-243
 *       external/cwe/cwe-252
 */

import cpp
import semmle.code.cpp.commons.Exclusions

/** Holds if a `fc` function call is available before or after a `chdir` function call. */
predicate inExistsChdir(FunctionCall fcp) {
  exists(FunctionCall fctmp |
    (
      fctmp.getTarget().hasGlobalOrStdName("chdir") or
      fctmp.getTarget().hasGlobalOrStdName("fchdir")
    ) and
    (
      fcp.getBasicBlock().getASuccessor*() = fctmp.getBasicBlock() or
      fctmp.getBasicBlock().getASuccessor*() = fcp.getBasicBlock()
    )
  )
}

/** Holds if a `fc` function call is available before or after a function call containing a `chdir` call. */
predicate outExistsChdir(FunctionCall fcp) {
  exists(FunctionCall fctmp |
    exists(FunctionCall fctmp2 |
      (
        fctmp2.getTarget().hasGlobalOrStdName("chdir") or
        fctmp2.getTarget().hasGlobalOrStdName("fchdir")
      ) and
      // we are looking for a call containing calls chdir and fchdir
      fctmp2.getEnclosingStmt().getParentStmt*() = fctmp.getTarget().getEntryPoint().getChildStmt*()
    ) and
    (
      fcp.getBasicBlock().getASuccessor*() = fctmp.getBasicBlock() or
      fctmp.getBasicBlock().getASuccessor*() = fcp.getBasicBlock()
    )
  )
}

from FunctionCall fc, string msg
where
  fc.getTarget().hasGlobalOrStdName("chroot") and
  not inExistsChdir(fc) and
  not outExistsChdir(fc) and
  // in this section I want to exclude calls to functions containing chroot that have a direct path to chdir, or to a function containing chdir
  exists(FunctionCall fctmp |
    fc.getEnclosingStmt().getParentStmt*() = fctmp.getTarget().getEntryPoint().getChildStmt*() and
    not inExistsChdir(fctmp) and
    not outExistsChdir(fctmp)
  ) and
  msg = "Creation of 'chroot' jail without changing the working directory"
  or
  (
    fc.getTarget().hasGlobalOrStdName("chdir") or
    fc.getTarget().hasGlobalOrStdName("fchdir")
  ) and
  fc instanceof ExprInVoidContext and
  not isFromMacroDefinition(fc) and
  msg = "Unchecked return value for call to '" + fc.getTarget().getName() + "'."
select fc, msg
