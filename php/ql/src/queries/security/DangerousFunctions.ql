/**
 * @name Dangerous function calls
 * @description Finds calls to dangerous PHP functions like eval, exec, system, etc.
 * @kind problem
 * @problem.severity error
 * @id php/dangerous-function-calls
 * @tags security
 */

import codeql.php.ast.internal.TreeSitter

from Php::FunctionCallExpression call, string name
where
  name = call.getFunction().(Php::Token).getValue() and
  name =
    [
      "eval", "exec", "system", "passthru", "shell_exec", "popen", "proc_open",
      "assert", "preg_replace", "create_function", "call_user_func",
      "call_user_func_array", "unserialize"
    ]
select call, "Call to dangerous function " + name + "()."
