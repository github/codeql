/**
 * @name Open file is not closed
 * @description A function always returns before closing a file that was opened in the function. Closing resources in the same function that opened them ties the lifetime of the resource to that of the function call, making it easier to avoid and detect resource leaks.
 * @kind problem
 * @id cpp/file-never-closed
 * @problem.severity warning
 * @security-severity 7.8
 * @tags efficiency
 *       security
 *       external/cwe/cwe-775
 */

import FileClosed

from Expr alloc
where fopenCall(alloc) and not fopenCallMayBeClosed(alloc)
select alloc, "The file is never closed"
