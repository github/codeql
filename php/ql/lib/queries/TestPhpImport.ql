/**
 * @name Test PHP import
 * @description Tests importing from the main php.qll module
 * @kind problem
 * @problem.severity warning
 * @id php/test-import
 */

import php

from FunctionCallExpression call, Name funcName
where
  call.getFunction() = funcName and
  funcName.getValue() in ["eval", "exec", "system", "shell_exec", "unserialize", "assert"]
select call, call.getLocation().getFile().getAbsolutePath() + ":" +
             call.getLocation().getStartLine().toString() +
             " - " + funcName.getValue()
