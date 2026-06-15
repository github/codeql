/**
 * @name Use of dangerous function
 * @description Use of a standard library function that does not guard against buffer overflow.
 * @kind problem
 * @problem.severity error
 * @security-severity 10.0
 * @precision very-high
 * @id cpp/dangerous-function-overflow
 * @tags reliability
 *       security
 *       external/cwe/cwe-242
 *       external/cwe/cwe-676
 */

import cpp

from FunctionCall call, Function target
where
  call.getTarget() = target and
  target.hasGlobalOrStdName("gets") and
  target.getNumberOfParameters() = 1
select call, "'gets' does not guard against buffer overflow."
