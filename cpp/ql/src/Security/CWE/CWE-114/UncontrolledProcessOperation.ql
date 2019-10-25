/**
 * @name Uncontrolled process operation
 * @description Using externally controlled strings in a process
 *              operation can allow an attacker to execute malicious
 *              commands.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/uncontrolled-process-operation
 * @tags security
 *       external/cwe/cwe-114
 */

import cpp
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking

from string processOperation, int processOperationArg, FunctionCall call, Expr arg, Element source
where
  isProcessOperationArgument(processOperation, processOperationArg) and
  call.getTarget().getName() = processOperation and
  call.getArgument(processOperationArg) = arg and
  tainted(source, arg)
select arg,
  "The value of this argument may come from $@ and is being passed to " + processOperation, source,
  source.toString()
