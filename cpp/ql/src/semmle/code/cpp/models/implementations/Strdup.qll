import semmle.code.cpp.models.interfaces.Allocation
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint

/**
 * A `strdup` style allocation function.
 */
class StrdupFunction extends AllocationFunction, ArrayFunction, DataFlowFunction {
  StrdupFunction() {
    exists(string name |
      hasGlobalOrStdName(name) and
      (
        // strdup(str)
        name = "strdup"
        or
        // wcsdup(str)
        name = "wcsdup"
      )
      or
      hasGlobalName(name) and
      (
        // _strdup(str)
        name = "_strdup"
        or
        // _wcsdup(str)
        name = "_wcsdup"
        or
        // _mbsdup(str)
        name = "_mbsdup"
      )
    )
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // These always copy the full value of the input buffer to the result
    // buffer
    input.isParameterDeref(0) and
    output.isReturnValueDeref()
  }
}
