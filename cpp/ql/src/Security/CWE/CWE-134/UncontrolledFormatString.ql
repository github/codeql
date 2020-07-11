/**
 * @name Uncontrolled format string
 * @description Using externally-controlled format strings in
 *              printf-style functions can lead to buffer overflows
 *              or data representation problems.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id cpp/tainted-format-string
 * @tags reliability
 *       security
 *       external/cwe/cwe-134
 */

import cpp
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.FunctionWithWrappers
import semmle.code.cpp.security.TaintTracking
import TaintedWithPath

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element tainted) {
    exists(PrintfLikeFunction printf | printf.outermostWrapperFunctionCall(tainted, _))
  }
}

from
  PrintfLikeFunction printf, Expr arg, PathNode sourceNode, PathNode sinkNode,
  string printfFunction, Expr userValue, string cause
where
  printf.outermostWrapperFunctionCall(arg, printfFunction) and
  taintedWithPath(userValue, arg, sourceNode, sinkNode) and
  isUserInput(userValue, cause)
select arg, sourceNode, sinkNode,
  "The value of this argument may come from $@ and is being used as a formatting argument to " +
    printfFunction, userValue, cause
