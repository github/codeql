/**
 * @name Use of potentially dangerous function
 * @description Use of a standard library function that is not thread-safe.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/potentially-dangerous-function
 * @tags reliability
 *       security
 *       external/cwe/cwe-676
 */

import cpp

predicate potentiallyDangerousFunction(Function f, string message) {
  exists(string name | f.hasGlobalName(name) |
    name = ["gmtime", "localtime", "ctime", "asctime"] and
    message = "Call to " + name + " is potentially dangerous"
  )
}

from FunctionCall call, Function target, string message
where
  call.getTarget() = target and
  potentiallyDangerousFunction(target, message)
select call, message
