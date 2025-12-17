/**
 * @name Test TreeSitter library with locations
 * @description Tests the regenerated TreeSitter.qll library with location info
 * @kind problem
 * @problem.severity warning
 * @id php/test-treesitter-loc
 */

import codeql.php.ast.internal.TreeSitter
import codeql.Locations as L

from PHP::FunctionCallExpression call, PHP::Name funcName, L::Location loc
where
  call.getFunction() = funcName and
  funcName.getValue() in ["eval", "exec", "system", "shell_exec", "unserialize", "popen"] and
  loc = call.getLocation()
select call, loc.getFile().getAbsolutePath() + ":" + loc.getStartLine().toString() + " - Dangerous: " + funcName.getValue()
