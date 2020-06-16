/**
 * @name Uses of recursion
 * @description Avoiding recursion allows tools and people to better analyze the program.
 * @kind problem
 * @id cpp/jpl-c/recursion
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       testability
 *       external/jpl
 */

import cpp

class RecursiveCall extends FunctionCall {
  RecursiveCall() { this.getTarget().calls*(this.getEnclosingFunction()) }
}

from RecursiveCall call, string msg
where
  if call.getTarget() = call.getEnclosingFunction()
  then msg = "This call directly invokes its containing function $@."
  else
    msg =
      "The function " + call.getEnclosingFunction() +
        " is indirectly recursive via this call to $@."
select call, msg, call.getTarget(), call.getTarget().getName()
