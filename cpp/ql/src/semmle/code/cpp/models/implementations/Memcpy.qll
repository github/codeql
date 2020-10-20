/**
 * Provides implementation classes modeling `memcpy` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.Taint

/**
 * The standard functions `memcpy`, `memmove` and `bcopy`; and the gcc variant
 * `__builtin___memcpy_chk`.
 */
class MemcpyFunction extends ArrayFunction, DataFlowFunction, SideEffectFunction {
  MemcpyFunction() {
    // memcpy(dest, src, num)
    // memmove(dest, src, num)
    // memmove(dest, src, num, remaining)
    this.hasName(["memcpy", "memmove", "__builtin___memcpy_chk"])
    or
    // bcopy(src, dest, num)
    this.hasGlobalOrStdName("bcopy")
  }

  /**
   * Gets the index of the parameter that is the source buffer for the copy.
   */
  int getParamSrc() { if this.hasGlobalOrStdName("bcopy") then result = 0 else result = 1 }

  /**
   * Gets the index of the parameter that is the destination buffer for the
   * copy.
   */
  int getParamDest() { if this.hasGlobalOrStdName("bcopy") then result = 1 else result = 0 }

  /**
   * Gets the index of the parameter that is the size of the copy (in bytes).
   */
  int getParamSize() { result = 2 }

  override predicate hasArrayInput(int bufParam) { bufParam = getParamSrc() }

  override predicate hasArrayOutput(int bufParam) { bufParam = getParamDest() }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(getParamSrc()) and
    output.isParameterDeref(getParamDest())
    or
    input.isParameterDeref(getParamSrc()) and
    output.isReturnValueDeref()
    or
    input.isParameter(getParamDest()) and
    output.isReturnValue()
  }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    (
      bufParam = getParamDest() or
      bufParam = getParamSrc()
    ) and
    countParam = getParamSize()
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = getParamDest() and buffer = true and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = getParamSrc() and buffer = true
  }

  override ParameterIndex getParameterSizeIndex(ParameterIndex i) {
    result = getParamSize() and
    (
      i = getParamDest() or
      i = getParamSrc()
    )
  }
}
