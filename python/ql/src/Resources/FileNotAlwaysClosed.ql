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

from FileOpen fo, string msg
where
  fileNotClosed(fo) and
  msg = "File is opened but is not closed."
  or
  fileMayNotBeClosedOnException(fo, _) and
  msg = "File may not be closed if an exception is raised."
select fo, msg
