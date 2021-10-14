/**
 * Provides implementation classes modeling `memcpy` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.Taint

/**
 * The standard functions `memcpy`, `memmove` and `bcopy`; and the gcc variant
 * `__builtin___memcpy_chk`.
 */
private class MemcpyFunction extends ArrayFunction, DataFlowFunction, SideEffectFunction,
  AliasFunction {
  MemcpyFunction() {
    // memcpy(dest, src, num)
    // memmove(dest, src, num)
    // memmove(dest, src, num, remaining)
    this.hasGlobalOrStdOrBslName(["memcpy", "memmove"])
    or
    // bcopy(src, dest, num)
    // mempcpy(dest, src, num)
    // memccpy(dest, src, c, n)
    this.hasGlobalName(["bcopy", mempcpy(), "memccpy", "__builtin___memcpy_chk"])
  }

  /**
   * Gets the index of the parameter that is the source buffer for the copy.
   */
  int getParamSrc() { if this.hasGlobalName("bcopy") then result = 0 else result = 1 }

  /**
   * Gets the index of the parameter that is the destination buffer for the
   * copy.
   */
  int getParamDest() { if this.hasGlobalName("bcopy") then result = 1 else result = 0 }

  /**
   * Gets the index of the parameter that is the size of the copy (in bytes).
   */
  int getParamSize() { if this.hasGlobalName("memccpy") then result = 3 else result = 2 }

  override predicate hasArrayInput(int bufParam) { bufParam = this.getParamSrc() }

  override predicate hasArrayOutput(int bufParam) { bufParam = this.getParamDest() }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(this.getParamSrc()) and
    output.isParameterDeref(this.getParamDest())
    or
    input.isParameterDeref(this.getParamSrc()) and
    output.isReturnValueDeref()
    or
    input.isParameter(this.getParamDest()) and
    output.isReturnValue()
  }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    (
      bufParam = this.getParamDest() or
      bufParam = this.getParamSrc()
    ) and
    countParam = this.getParamSize()
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = this.getParamDest() and
    buffer = true and
    // memccpy only writes until a given character `c` is found
    (if this.hasGlobalName("memccpy") then mustWrite = false else mustWrite = true)
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = this.getParamSrc() and buffer = true
  }

  override ParameterIndex getParameterSizeIndex(ParameterIndex i) {
    result = this.getParamSize() and
    (
      i = this.getParamDest() or
      i = this.getParamSrc()
    )
  }

  override predicate parameterNeverEscapes(int index) {
    index = this.getParamSrc()
    or
    this.hasGlobalName("bcopy") and index = this.getParamDest()
  }

  override predicate parameterEscapesOnlyViaReturn(int index) {
    not this.hasGlobalName("bcopy") and index = this.getParamDest()
  }

  override predicate parameterIsAlwaysReturned(int index) {
    not this.hasGlobalName(["bcopy", mempcpy(), "memccpy"]) and
    index = this.getParamDest()
  }
}

private string mempcpy() { result = ["mempcpy", "wmempcpy"] }
