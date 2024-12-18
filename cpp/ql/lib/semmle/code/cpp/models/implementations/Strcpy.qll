/**
 * Provides implementation classes modeling `strcpy` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.NonThrowing

/**
 * The standard function `strcpy` and its wide, sized, and Microsoft variants.
 */
class StrcpyFunction extends ArrayFunction, DataFlowFunction, TaintFunction, SideEffectFunction,
  NonCppThrowingFunction
{
  StrcpyFunction() {
    this.hasGlobalOrStdOrBslName([
        "strcpy", // strcpy(dst, src)
        "wcscpy", // wcscpy(dst, src)
        "strncpy", // strncpy(dst, src, max_amount)
        "wcsncpy", // wcsncpy(dst, src, max_amount)
        "strxfrm", // strxfrm(dest, src, max_amount)
        "wcsxfrm" // wcsxfrm(dest, src, max_amount)
      ])
    or
    this.hasGlobalName([
        "_mbscpy", // _mbscpy(dst, src)
        "_strncpy_l", // _strncpy_l(dst, src, max_amount, locale)
        "_wcsncpy_l", // _wcsncpy_l(dst, src, max_amount, locale)
        "_mbsncpy", // _mbsncpy(dst, src, max_amount)
        "_mbsncpy_l", // _mbsncpy_l(dst, src, max_amount, locale)
        "_strxfrm_l", // _strxfrm_l(dest, src, max_amount, locale)
        "wcsxfrm_l", // _strxfrm_l(dest, src, max_amount, locale)
        "_mbsnbcpy", // _mbsnbcpy(dest, src, max_amount)
        "stpcpy", // stpcpy(dest, src)
        "stpncpy", // stpncpy(dest, src, max_amount)
        "strlcpy" // strlcpy(dst, src, dst_size)
      ])
    or
    (
      this.hasGlobalOrStdName([
          "strcpy_s", // strcpy_s(dst, max_amount, src)
          "wcscpy_s" // wcscpy_s(dst, max_amount, src)
        ])
      or
      this.hasGlobalName("_mbscpy_s") // _mbscpy_s(dst, max_amount, src)
    ) and
    // exclude the 2-parameter template versions
    // that find the size of a fixed size destination buffer.
    this.getNumberOfParameters() = 3
  }

  /**
   * Holds if this is one of the `strcpy_s` variants.
   */
  private predicate isSVariant() { this.getName().matches("%\\_s") }

  /**
   * Holds if the function returns the total length the string would have had if the size was unlimited.
   */
  private predicate returnsTotalLength() { this.getName() = "strlcpy" }

  /**
   * Gets the index of the parameter that is the maximum size of the copy (in characters).
   */
  int getParamSize() {
    if this.isSVariant()
    then result = 1
    else (
      this.getName().matches(["%ncpy%", "%nbcpy%", "%xfrm%", "strlcpy"]) and
      result = 2
    )
  }

  /**
   * Gets the index of the parameter that is the source of the copy.
   */
  int getParamSrc() { if this.isSVariant() then result = 2 else result = 1 }

  /**
   * Gets the index of the parameter that is the destination of the copy.
   */
  int getParamDest() { result = 0 }

  override predicate hasArrayInput(int bufParam) { bufParam = this.getParamSrc() }

  override predicate hasArrayOutput(int bufParam) { bufParam = this.getParamDest() }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = this.getParamSrc() }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    bufParam = this.getParamDest() and
    countParam = this.getParamSize()
  }

  override predicate hasArrayWithUnknownSize(int bufParam) {
    not exists(this.getParamSize()) and
    bufParam = this.getParamDest()
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    not exists(this.getParamSize()) and
    input.isParameterDeref(this.getParamSrc()) and
    output.isParameterDeref(this.getParamDest())
    or
    not exists(this.getParamSize()) and
    input.isParameterDeref(this.getParamSrc()) and
    output.isReturnValueDeref()
    or
    not this.returnsTotalLength() and
    input.isParameter(this.getParamDest()) and
    output.isReturnValue()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // these may do only a partial copy of the input buffer to the output
    // buffer
    exists(this.getParamSize()) and
    input.isParameterDeref(this.getParamSrc()) and
    (
      output.isParameterDeref(this.getParamDest())
      or
      not this.returnsTotalLength() and output.isReturnValueDeref()
    )
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = this.getParamDest() and
    buffer = true and
    mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = this.getParamSrc() and
    buffer = true
  }

  override ParameterIndex getParameterSizeIndex(ParameterIndex i) {
    i = this.getParamDest() and
    result = this.getParamSize()
  }
}
