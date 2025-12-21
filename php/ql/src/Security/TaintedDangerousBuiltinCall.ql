/**
 * @name Dangerous builtin called with untrusted input
 * @description Finds calls to dangerous builtins where at least one argument directly uses a PHP superglobal.
 * @kind problem
 * @problem.severity warning
 * @id php/security/tainted-dangerous-builtin-call
 */

import codeql.php.ast.Calls
import codeql.php.security.Sinks
import codeql.php.security.Taint

from FunctionCall call
where
  PhpSecuritySinks::isDangerousBuiltinCall(call) and
  PhpSecurityTaint::hasTaintedArgument(call)
select call, "This dangerous builtin is called with an argument that directly uses a superglobal."
