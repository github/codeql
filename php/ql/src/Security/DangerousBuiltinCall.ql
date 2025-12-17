/**
 * @name Call to dangerous PHP built-in
 * @description A call to a PHP built-in that is commonly dangerous when used with untrusted input.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id php/dangerous-builtin-call
 * @tags security
 */

import codeql.php.ast.Calls

from FunctionCall call
where call.getCalleeName() in ["eval", "assert", "unserialize", "system", "exec"]
select call, "Use of dangerous PHP built-in: '" + call.getCalleeName() + "'."
