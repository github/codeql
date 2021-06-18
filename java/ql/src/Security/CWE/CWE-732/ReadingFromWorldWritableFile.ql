/**
 * @name Reading from a world writable file
 * @description Reading from a file which is set as world writable is dangerous because
 *              the file may be modified or removed by external actors.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id java/world-writable-file-read
 * @tags security
 *       external/cwe/cwe-732
 */

import java
import semmle.code.java.security.FileReadWrite
import semmle.code.java.security.FileWritable

from Variable fileVariable, FileReadExpr readFrom, SetFileWorldWritable setWorldWritable
where
  // The file variable must be both read from and set to world writable. This is not flow-sensitive.
  fileVariable.getAnAccess() = readFrom.getFileVarAccess() and
  fileVariable.getAnAccess() = setWorldWritable.getFileVarAccess() and
  // If the file variable is a parameter, the result should be reported in the caller.
  not fileVariable instanceof Parameter
select setWorldWritable, "A file is set to be world writable here, but is read from $@.", readFrom,
  "statement"
