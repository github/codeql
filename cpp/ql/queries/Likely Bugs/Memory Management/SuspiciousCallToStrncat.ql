/**
 * @name Potentially unsafe call to strncat
 * @description Calling 'strncat' with the size of the destination buffer
 *              as the third argument may result in a buffer overflow.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/unsafe-strncat
 * @tags reliability
 *       correctness
 *       security
 *       external/cwe/cwe-676
 *       external/cwe/cwe-119
 *       external/cwe/cwe-251
 */

import cpp
import Buffer

from FunctionCall fc, VariableAccess va1, VariableAccess va2
where
  fc.getTarget().(Function).hasName("strncat") and
  va1 = fc.getArgument(0) and
  va2 = fc.getArgument(2).(BufferSizeExpr).getArg() and
  va1.getTarget() = va2.getTarget()
select fc, "Potentially unsafe call to strncat."
