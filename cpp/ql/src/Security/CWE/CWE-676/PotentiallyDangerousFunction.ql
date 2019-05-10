/**
 * @name Use of potentially dangerous function
 * @description Certain standard library functions are dangerous to call.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/potentially-dangerous-function
 * @tags reliability
 *       security
 *       external/cwe/cwe-242
 */
import cpp

predicate potentiallyDangerousFunction(Function f, string message) {
  exists(string name | f.hasGlobalName(name) |
    (
      name = "gmtime" or
      name = "localtime" or
      name = "ctime" or
      name = "asctime"
    ) and
    message = "Call to " + name + " is potentially dangerous"
  )
}


from FunctionCall call, Function target, string message
where
  call.getTarget() = target and
  potentiallyDangerousFunction(target, message)
select call, message
