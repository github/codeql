/**
 * @name Uncontrolled data used in OS command
 * @description Using user-supplied data in an OS command, without
 *              neutralizing special elements, can make code vulnerable
 *              to command injection.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id cpp/command-line-injection
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import cpp
import semmle.code.cpp.security.CommandExecution
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking

from Expr taintedArg, Expr taintSource, string taintCause, string callChain
where
  shellCommand(taintedArg, callChain) and
  tainted(taintSource, taintedArg) and
  isUserInput(taintSource, taintCause)
select taintedArg,
  "This argument to an OS command is derived from $@ and then passed to " + callChain, taintSource,
  "user input (" + taintCause + ")"
