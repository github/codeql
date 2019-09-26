import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.DataFlow

/**
 * The standard function `memset` and its assorted variants
 */
class MemsetFunction extends ArrayFunction, DataFlowFunction {
  MemsetFunction() {
    hasGlobalName("memset") or
    hasGlobalName("wmemset") or
    hasGlobalName("bzero") or
    hasGlobalName("__builtin_memset") or
    hasGlobalName("__builtin_memset_chk") or
    hasQualifiedName("std", "memset") or
    hasQualifiedName("std", "wmemset")
  }

  override predicate hasArrayOutput(int bufParam) { bufParam = 0 }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isInParameter(0) and
    output.isOutReturnValue()
  }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    bufParam = 0 and
    (if hasGlobalName("bzero") then countParam = 1 else countParam = 2)
  }
}
