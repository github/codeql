/**
 * @name Uncontrolled format string (through global variable)
 * @description Using externally-controlled format strings in
 *              printf-style functions can lead to buffer overflows
 *              or data representation problems.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/tainted-format-string-through-global
 * @tags reliability
 *       security
 *       external/cwe/cwe-134
 */

import cpp
import semmle.code.cpp.security.FunctionWithWrappers
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking

from
  PrintfLikeFunction printf, Expr arg, string printfFunction, Expr userValue, string cause,
  string globalVar
where
  printf.outermostWrapperFunctionCall(arg, printfFunction) and
  not tainted(_, arg) and
  taintedIncludingGlobalVars(userValue, arg, globalVar) and
  isUserInput(userValue, cause)
select arg,
  "This value may flow through $@, originating from $@, and is a formatting argument to " +
    printfFunction + ".", globalVarFromId(globalVar), globalVar, userValue, cause
