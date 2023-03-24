/**
 * @name Dangerous use SSL_shutdown.
 * @description Incorrect closing of the connection leads to the creation of different states for the server and client, which can be exploited by an attacker.
 * @kind problem
 * @id cpp/dangerous-use-of-ssl-shutdown
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       experimental
 *       external/cwe/cwe-670
 */

import cpp
import semmle.code.cpp.commons.Exclusions
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

from FunctionCall fc, FunctionCall fc1
where
  fc != fc1 and
  fc.getASuccessor+() = fc1 and
  fc.getTarget().hasName("SSL_shutdown") and
  fc1.getTarget().hasName("SSL_shutdown") and
  fc1 instanceof ExprInVoidContext and
  (
    globalValueNumber(fc.getArgument(0)) = globalValueNumber(fc1.getArgument(0)) or
    fc.getArgument(0).(VariableAccess).getTarget() = fc1.getArgument(0).(VariableAccess).getTarget()
  ) and
  not exists(FunctionCall fctmp |
    fctmp.getTarget().hasName("SSL_free") and
    fc.getASuccessor+() = fctmp and
    fctmp.getASuccessor+() = fc1
  )
select fc, "You need to handle the return value 'SSL_shutdown'."
