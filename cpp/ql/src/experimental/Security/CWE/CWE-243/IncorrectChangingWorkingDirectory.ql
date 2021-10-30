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
      fctmp.getASuccessor*() = fcp or
      fcp.getASuccessor*() = fctmp
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
      fctmp.getASuccessor*() = fcp or
      fcp.getASuccessor*() = fctmp
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
  not exists(ConditionalStmt cotmp | cotmp.getControllingExpr().getAChild*() = fc) and
  not exists(Loop lptmp | lptmp.getCondition().getAChild*() = fc) and
  not exists(ReturnStmt rttmp | rttmp.getExpr().getAChild*() = fc) and
  not exists(Assignment astmp | astmp.getAChild*() = fc) and
  not exists(Initializer ittmp | ittmp.getExpr().getAChild*() = fc) and
  not isFromMacroDefinition(fc)
  msg = "Unchecked return value for call to '" + fc.getTarget().getName() + "'."
select fc, msg
