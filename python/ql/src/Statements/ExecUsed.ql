/**
 * @name 'exec' used
 * @description The 'exec' statement or function is used which could cause arbitrary code to be executed.
 * @kind problem
 * @tags security
 *       correctness
 * @problem.severity error
 * @sub-severity high
 * @precision low
 * @id py/use-of-exec
 */

import python

string message() {
  result = "The 'exec' statement is used." and major_version() = 2
  or
  result = "The 'exec' function is used." and major_version() = 3
}

predicate exec_function_call(Call c) {
  exists(GlobalVariable exec | exec = c.getFunc().(Name).getVariable() and exec.getId() = "exec")
}

from AstNode exec
where exec_function_call(exec) or exec instanceof Exec
select exec, message()
