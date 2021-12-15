/**
 * @name Use of recursion
 * @description Recursion makes the program call graph cyclic and hinders
 *              program understanding.
 * @kind problem
 * @id cpp/power-of-10/use-of-recursion
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/powerof10
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
