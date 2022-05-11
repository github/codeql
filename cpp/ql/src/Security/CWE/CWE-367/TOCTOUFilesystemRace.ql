/**
 * @name Time-of-check time-of-use filesystem race condition
 * @description Separately checking the state of a file before operating
 *              on it may allow an attacker to modify the file between
 *              the two operations.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.7
 * @precision high
 * @id cpp/toctou-race-condition
 * @tags security
 *       external/cwe/cwe-367
 */

import cpp
import semmle.code.cpp.controlflow.Guards

/**
 * An operation on a filename that is likely to modify the corresponding file
 * and may return an indication of success.
 *
 * Note: we're not interested in operations where the file is specified by a
 * descriptor, rather than a filename, as they are better behaved. We are
 * interested in functions that take a filename and return a file descriptor,
 * however.
 */
FunctionCall filenameOperation(Expr path) {
  exists(string name | name = result.getTarget().getName() |
    name =
      [
        "remove", "unlink", "rmdir", "rename", "fopen", "open", "freopen", "_open", "_wopen",
        "_wfopen", "_fsopen", "_wfsopen"
      ] and
    result.getArgument(0) = path
    or
    name = ["fopen_s", "wfopen_s", "rename"] and
    result.getArgument(1) = path
  )
  or
  result = sensitiveFilenameOperation(path)
}

/**
 * An operation on a filename that is likely to modify the security properties
 * of the corresponding file and may return an indication of success.
 */
FunctionCall sensitiveFilenameOperation(Expr path) {
  exists(string name | name = result.getTarget().getName() |
    name = ["chmod", "chown"] and
    result.getArgument(0) = path
  )
}

/**
 * An operation on a filename that returns information in the return value but
 * does not modify the corresponding file.  For example, `access`.
 */
FunctionCall accessCheck(Expr path) {
  exists(string name | name = result.getTarget().getName() |
    name = ["access", "_access", "_waccess", "_access_s", "_waccess_s"]
  ) and
  path = result.getArgument(0)
}

/**
 * An operation on a filename that returns information via a pointer argument
 * and any return value, but does not modify the corresponding file.  For
 * example, `stat`.
 */
FunctionCall stat(Expr path, Expr buf) {
  exists(string name | name = result.getTarget().getName() |
    name = ["stat", "lstat", "fstat"] or
    name.matches("\\_stat%") or
    name.matches("\\_wstat%")
  ) and
  path = result.getArgument(0) and
  buf = result.getArgument(1)
}

/**
 * Holds if `use` refers to `source`, either by being the same or by
 * one step of variable indirection.
 */
predicate referenceTo(Expr source, Expr use) {
  source = use
  or
  exists(SsaDefinition def, StackVariable v |
    def.getAnUltimateDefiningValue(v) = source and def.getAUse(v) = use
  )
}

pragma[noinline]
predicate statCallWithPointer(Expr checkPath, Expr call, Expr e, Variable v) {
  call = stat(checkPath, e) and
  e.getAChild*().(VariableAccess).getTarget() = v
}

predicate checksPath(Expr check, Expr checkPath) {
  // either:
  // an access check
  check = accessCheck(checkPath)
  or
  // a stat
  check = stat(checkPath, _)
  or
  // access to a member variable on the stat buf
  // (morally, this should be a use-use pair, but it seems unlikely
  // that this variable will get reused in practice)
  exists(Expr call, Expr e, Variable v |
    statCallWithPointer(checkPath, call, e, v) and
    check.(VariableAccess).getTarget() = v and
    not e.getAChild*() = check // the call that writes to the pointer is not where the pointer is checked.
  )
}

pragma[nomagic]
predicate checkPathControlsUse(Expr check, Expr checkPath, Expr use) {
  exists(GuardCondition guard | referenceTo(check, guard.getAChild*()) |
    guard.controls(use.getBasicBlock(), _)
  ) and
  checksPath(pragma[only_bind_into](check), checkPath)
}

pragma[nomagic]
predicate fileNameOperationControlsUse(Expr check, Expr checkPath, Expr use) {
  exists(GuardCondition guard | referenceTo(check, guard.getAChild*()) |
    guard.controls(use.getBasicBlock(), _)
  ) and
  pragma[only_bind_into](check) = filenameOperation(checkPath)
}

predicate checkUse(Expr check, Expr checkPath, FunctionCall use, Expr usePath) {
  // `check` is part of a guard that controls `use`
  checkPathControlsUse(check, checkPath, use) and
  // `check` looks like a check on a filename
  checksPath(check, checkPath) and
  // `op` looks like an operation on a filename
  use = filenameOperation(usePath)
  or
  // `check` is part of a guard that controls `use`
  fileNameOperationControlsUse(check, checkPath, use) and
  // another filename operation (null pointers can indicate errors)
  check = filenameOperation(checkPath) and
  // `op` looks like a sensitive operation on a filename
  use = sensitiveFilenameOperation(usePath)
}

pragma[noinline]
predicate isCheckedPath(
  Expr check, SsaDefinition def, StackVariable v, FunctionCall use, Expr usePath, Expr checkPath
) {
  checkUse(check, checkPath, use, usePath) and
  def.getAUse(v) = checkPath
}

pragma[noinline]
predicate isUsedPath(
  Expr check, SsaDefinition def, StackVariable v, FunctionCall use, Expr usePath, Expr checkPath
) {
  checkUse(check, checkPath, use, usePath) and
  def.getAUse(v) = usePath
}

from Expr check, Expr checkPath, FunctionCall use, Expr usePath, SsaDefinition def, StackVariable v
where
  // `checkPath` and `usePath` refer to the same SSA variable
  isCheckedPath(check, def, v, use, usePath, checkPath) and
  isUsedPath(check, def, v, use, usePath, checkPath)
select use,
  "The $@ being operated upon was previously $@, but the underlying file may have been changed since then.",
  usePath, "filename", check, "checked"
