/**
 * @name Use of potentially dangerous function
 * @description Certain standard library functions are dangerous to call.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/potentially-dangerous-function
 * @tags reliability
 *       security
 *       external/cwe/cwe-676
 */
import cpp


predicate dangerousFunction(Function function) {
  exists (string name | name = function.getQualifiedName() |
    name = "gmtime")
}


from FunctionCall call, Function target
where call.getTarget() = target
  and dangerousFunction(target)
select call, "Call to " + target.getQualifiedName() + " is potentially dangerous"
