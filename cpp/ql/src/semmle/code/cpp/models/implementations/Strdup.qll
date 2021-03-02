/**
 * Provides implementation classes modeling `strdup` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.models.interfaces.Allocation
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint

/**
 * A `strdup` style allocation function.
 */
private class StrdupFunction extends AllocationFunction, ArrayFunction, DataFlowFunction {
  StrdupFunction() {
    hasGlobalName([
        // --- C library allocation
        "strdup", // strdup(str)
        "wcsdup", // wcsdup(str)
        "_strdup", // _strdup(str)
        "_wcsdup", // _wcsdup(str)
        "_mbsdup" // _mbsdup(str)
      ])
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isReturnValueDeref()
  }
}

/**
 * A `strndup` style allocation function.
 */
private class StrndupFunction extends AllocationFunction, ArrayFunction, DataFlowFunction {
  StrndupFunction() {
    exists(string name |
      hasGlobalName(name) and
      // --- C library allocation
      name = "strndup" // strndup(str, maxlen)
    )
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isParameterDeref(0) or
      input.isParameter(1)
    ) and
    output.isReturnValueDeref()
  }
}
