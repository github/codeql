/**
 * @name File created without restricting permissions
 * @description Creating a file that is world-writable can allow an attacker to write to the file.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision medium
 * @id cpp/world-writable-file-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import cpp
import FilePermissions
import semmle.code.cpp.ConfigurationTestFile

predicate worldWritableCreation(FileCreationExpr fc, int mode) {
  mode = localUmask(fc).mask(fc.getMode()) and
  setsAnyBits(mode, UnixConstants::s_iwoth())
}

predicate setWorldWritable(FunctionCall fc, int mode) {
  fc.getTarget().getName() = ["chmod", "fchmod", "_chmod", "_wchmod"] and
  mode = fc.getArgument(1).getValue().toInt() and
  setsAnyBits(mode, UnixConstants::s_iwoth())
}

from Expr fc, int mode, string message
where
  worldWritableCreation(fc, mode) and
  not fc.getFile() instanceof ConfigurationTestFile and // expressions in files generated during configuration are likely false positives
  message =
    "A file may be created here with mode " + octalFileMode(mode) +
      ", which would make it world-writable."
  or
  setWorldWritable(fc, mode) and
  message =
    "This sets a file's permissions to " + octalFileMode(mode) +
      ", which would make it world-writable."
select fc, message
