/**
 * @name Use of debugger statement
 * @description The 'debugger' statement should not be used in production code.
 * @kind problem
 * @problem.severity recommendation
 * @id js/debugger-statement
 * @tags quality
 *       reliability
 *       correctness
 *       performance
 *       external/cwe/cwe-489
 * @precision medium
 */

import javascript

from DebuggerStmt ds
select ds, "Do not use 'debugger'."
