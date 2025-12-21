/**
 * @name Test TreeSitter library
 * @description Tests the regenerated TreeSitter.qll library
 * @kind problem
 * @problem.severity recommendation
 * @id php/test-treesitter
 */

import codeql.php.ast.internal.TreeSitter

from PHP::FunctionCallExpression call, PHP::Name funcName
where
  call.getFunction() = funcName and
  funcName.getValue() in ["eval", "exec", "system", "shell_exec", "unserialize"]
select call, "Dangerous function call: " + funcName.getValue()
