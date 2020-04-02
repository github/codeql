import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The standard function `strcpy` and its wide, sized, and Microsoft variants.
 */
class StrcpyFunction extends ArrayFunction, DataFlowFunction, TaintFunction, SideEffectFunction {
  StrcpyFunction() {
    this.hasName("strcpy") or
    this.hasName("_mbscpy") or
    this.hasName("wcscpy") or
    this.hasName("strncpy") or
    this.hasName("_strncpy_l") or
    this.hasName("_mbsncpy") or
    this.hasName("_mbsncpy_l") or
    this.hasName("wcsncpy") or
    this.hasName("_wcsncpy_l")
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 1 }

  override predicate hasArrayOutput(int bufParam) { bufParam = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 1 }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    (
      this.hasName("strncpy") or
      this.hasName("_strncpy_l") or
      this.hasName("_mbsncpy") or
      this.hasName("_mbsncpy_l") or
      this.hasName("wcsncpy") or
      this.hasName("_wcsncpy_l")
    ) and
    bufParam = 0 and
    countParam = 2
  }

  override predicate hasArrayWithUnknownSize(int bufParam) {
    (
      this.hasName("strcpy") or
      this.hasName("_mbscpy") or
      this.hasName("wcscpy")
    ) and
    bufParam = 0
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(1) and
    output.isParameterDeref(0)
    or
    input.isParameterDeref(1) and
    output.isReturnValueDeref()
    or
    input.isParameter(0) and
    output.isReturnValue()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      // these may do only a partial copy of the input buffer to the output
      // buffer
      this.hasName("strncpy") or
      this.hasName("_strncpy_l") or
      this.hasName("_mbsncpy") or
      this.hasName("_mbsncpy_l") or
      this.hasName("wcsncpy") or
      this.hasName("_wcsncpy_l")
    ) and
    input.isParameter(2) and
    (
      output.isParameterDeref(0) or
      output.isReturnValueDeref()
    )
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 0 and
    buffer = true and
    mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 1 and
    buffer = true
  }

  override ParameterIndex getParameterSizeIndex(ParameterIndex i) {
    hasArrayWithVariableSize(i, result)
  }
}
