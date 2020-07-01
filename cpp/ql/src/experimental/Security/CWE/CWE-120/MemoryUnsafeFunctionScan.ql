/**
 * @name Scanf function without a specified length
 * @description Use of one of the scanf functions without a specified length.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/memory-unsafe-function-scan
 * @tags reliability
 *       security
 *       external/cwe/cwe-120
 */

import cpp
import semmle.code.cpp.commons.Scanf


from FunctionCall call, ScanfFunction sff
where
  call.getTarget() = sff
  and
  (
  call.getArgument(sff.getFormatParameterIndex()).toString().regexpMatch(".*%s.*")
  or
  call.getArgument(sff.getFormatParameterIndex()).toString() = (".*%ls.*")
  )
select call, "Dangerous use of one of the scanf functions"