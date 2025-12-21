/**
 * @name Test AST library
 * @description Tests the rewritten AST.qll library
 * @kind problem
 * @problem.severity recommendation
 * @id php/test-ast
 */

import codeql.php.AST

from FunctionCallExpression call, Name funcName
where
  call.getFunction() = funcName and
  funcName.getValue() in ["eval", "exec", "system", "shell_exec", "unserialize"]
select call, call.getLocation().getFile().getAbsolutePath() + ":" +
             call.getLocation().getStartLine().toString() +
             " - Dangerous: " + funcName.getValue()
