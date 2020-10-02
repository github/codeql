/**
 * @name File created without restricting permissions
 * @description Creating a file that is world-writable can allow an attacker to write to the file.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/world-writable-file-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import cpp
import FilePermissions
import semmle.code.cpp.commons.unix.Constants

predicate worldWritableCreation(FileCreationExpr fc, int mode) {
  mode = localUmask(fc).mask(fc.getMode()) and
  sets(mode, s_iwoth())
}

predicate setWorldWritable(FunctionCall fc, int mode) {
  fc.getTarget().getName() = ["chmod", "fchmod", "_chmod", "_wchmod"] and
  mode = fc.getArgument(1).getValue().toInt() and
  sets(mode, s_iwoth())
}

from Expr fc, int mode, string message
where
  worldWritableCreation(fc, mode) and
  message =
    "A file may be created here with mode " + octalFileMode(mode) +
      ", which would make it world-writable."
  or
  setWorldWritable(fc, mode) and
  message =
    "This sets a file's permissions to " + octalFileMode(mode) +
      ", which would make it world-writable."
select fc, message
