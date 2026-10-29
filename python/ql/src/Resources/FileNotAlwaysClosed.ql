/**
 * @name File is not always closed
 * @description Opening a file without ensuring that it is always closed may lead to data loss or resource leaks.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 *       performance
 *       external/cwe/cwe-772
 * @problem.severity warning
 * @sub-severity high
 * @precision high
 * @id py/file-not-closed
 */

import python
import FileNotAlwaysClosedQuery
import codeql.util.Option

from FileOpen fo, string msg, LocatableOption<Location, DataFlow::Node>::Option exec
where
  fileNotClosed(fo) and
  msg = "File is opened but is not closed." and
  exec.isNone()
  or
  fileMayNotBeClosedOnException(fo, exec.asSome()) and
  msg = "File may not be closed if $@ raises an exception."
select fo, msg, exec, "this operation"
