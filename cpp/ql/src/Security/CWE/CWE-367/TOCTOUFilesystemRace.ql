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

from Expr check, Expr checkPath, FunctionCall use, Expr usePath
where
  // `check` looks like a check on a filename
  (
    (
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
        call = stat(checkPath, e) and
        e.getAChild*().(VariableAccess).getTarget() = v and
        check.(VariableAccess).getTarget() = v and
        not e.getAChild*() = check // the call that writes to the pointer is not where the pointer is checked.
      )
    ) and
    // `op` looks like an operation on a filename
    use = filenameOperation(usePath)
    or
    // another filename operation (null pointers can indicate errors)
    check = filenameOperation(checkPath) and
    // `op` looks like a sensitive operation on a filename
    use = sensitiveFilenameOperation(usePath)
  ) and
  // `checkPath` and `usePath` refer to the same SSA variable
  exists(SsaDefinition def, StackVariable v |
    def.getAUse(v) = checkPath and def.getAUse(v) = usePath
  ) and
  // the return value of `check` is used (possibly with one step of
  // variable indirection) in a guard which controls `use`
  exists(GuardCondition guard | referenceTo(check, guard.getAChild*()) |
    guard.controls(use.(ControlFlowNode).getBasicBlock(), _)
  )
select use,
  "The $@ being operated upon was previously $@, but the underlying file may have been changed since then.",
  usePath, "filename", check, "checked"
