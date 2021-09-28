/**
 * @name Uncontrolled format string (through global variable)
 * @description Using externally-controlled format strings in
 *              printf-style functions can lead to buffer overflows
 *              or data representation problems.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision high
 * @id cpp/tainted-format-string-through-global
 * @tags reliability
 *       security
 *       external/cwe/cwe-134
 */

import cpp
import semmle.code.cpp.security.FunctionWithWrappers
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking
import TaintedWithPath

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element tainted) {
    exists(PrintfLikeFunction printf | printf.outermostWrapperFunctionCall(tainted, _))
  }

  override predicate taintThroughGlobals() { any() }
}

from
  PrintfLikeFunction printf, Expr arg, PathNode sourceNode, PathNode sinkNode,
  string printfFunction, Expr userValue, string cause
where
  printf.outermostWrapperFunctionCall(arg, printfFunction) and
  not taintedWithoutGlobals(arg) and
  taintedWithPath(userValue, arg, sourceNode, sinkNode) and
  isUserInput(userValue, cause)
select arg, sourceNode, sinkNode,
  "The value of this argument may come from $@ and is being used as a formatting argument to " +
    printfFunction, userValue, cause
