/**
 * @name Return value of a function is ignored
 * @description A call to a function ignores its return value, but more than 80% of the total number of calls to the function check the return value. Check the return value of functions consistently, especially for functions like 'fread' or the 'scanf' functions that return the status of the operation.
 * @kind problem
 * @id cpp/return-value-ignored
 * @problem.severity recommendation
 * @precision medium
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-252
 */

import cpp

predicate unused(Expr e) { e instanceof ExprInVoidContext }

predicate important(Function f, string message) {
  message = "the result of this function must always be checked." and
  getOptions().alwaysCheckReturnValue(f)
}

// statistically dubious ignored return values
predicate dubious(Function f, string message) {
  not important(f, _) and
  exists(Options opts, int used, int total, int percentage |
    used =
      count(FunctionCall fc |
        fc.getTarget() = f and not opts.okToIgnoreReturnValue(fc) and not unused(fc)
      ) and
    total = count(FunctionCall fc | fc.getTarget() = f and not opts.okToIgnoreReturnValue(fc)) and
    used != total and
    percentage = used * 100 / total and
    percentage >= 90 and
    message = percentage.toString() + "% of calls to this function have their result used."
  )
}

from FunctionCall unused, string message
where
  unused(unused) and
  not exists(Options opts | opts.okToIgnoreReturnValue(unused)) and
  (important(unused.getTarget(), message) or dubious(unused.getTarget(), message)) and
  not unused.getTarget().getName().matches("operator%") // exclude user defined operators
select unused, "Result of call to " + unused.getTarget().getName() + " is ignored; " + message
