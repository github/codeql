/**
 * @name Uncontrolled format string
 * @description Using externally-controlled format strings in
 *              printf-style functions can lead to buffer overflows
 *              or data representation problems.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/tainted-format-string
 * @tags reliability
 *       security
 *       external/cwe/cwe-134
 */

import cpp
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.FunctionWithWrappers
import semmle.code.cpp.security.TaintTracking

from PrintfLikeFunction printf, Expr arg, string printfFunction, Expr userValue, string cause
where
  printf.outermostWrapperFunctionCall(arg, printfFunction) and
  tainted(userValue, arg) and
  isUserInput(userValue, cause)
select arg,
  "The value of this argument may come from $@ and is being used as a formatting argument to " +
    printfFunction, userValue, cause
