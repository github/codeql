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
  (
    f.getQualifiedName() = "gmtime" and
    message = "Call to gmtime is potentially dangerous"
  ) or (
    f.getQualifiedName() = "gets" and
    message = "gets does not guard against buffer overflow"
  )
}


from FunctionCall call, Function target, string message
where
  call.getTarget() = target and
  potentiallyDangerousFunction(target, message)
select call, message
