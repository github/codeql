/**
 * @name Standard library function that is not memory-safe without a specified length
 * @description Use of a standard library function that is not memory-safe without a specified length.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/memory-unsafe-function-scan
 * @tags reliability
 *       security
 *       external/cwe/cwe-120
 */

import cpp

predicate memoryUnsafeFunctionParameter(Call c, string message) {
  exists(string name | c.getTarget().hasGlobalName(name) |
    (
      (
        name = "scanf" or
        name = "sscanf" or
        name = "fscanf"
      )
    ) and
    message = "Call to " + name + " is potentially dangerous. Please use " + name + "_s to avoid buffer overflows."
  )
}

from FunctionCall call, string message
where
memoryUnsafeFunctionParameter(call, message)
select call, message
