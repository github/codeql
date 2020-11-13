/**
 * Provides implementation classes modeling `strcpy` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The standard function `strcpy` and its wide, sized, and Microsoft variants.
 */
class StrcpyFunction extends ArrayFunction, DataFlowFunction, TaintFunction, SideEffectFunction {
  StrcpyFunction() {
    getName() =
      [
        "strcpy", // strcpy(dst, src)
        "wcscpy", // wcscpy(dst, src)
        "_mbscpy", // _mbscpy(dst, src)
        "strncpy", // strncpy(dst, src, max_amount)
        "_strncpy_l", // _strncpy_l(dst, src, max_amount, locale)
        "wcsncpy", // wcsncpy(dst, src, max_amount)
        "_wcsncpy_l", // _wcsncpy_l(dst, src, max_amount, locale)
        "_mbsncpy", // _mbsncpy(dst, src, max_amount)
        "_mbsncpy_l" // _mbsncpy_l(dst, src, max_amount, locale)
      ]
    or
    getName() =
      [
        "strcpy_s", // strcpy_s(dst, max_amount, src)
        "wcscpy_s", // wcscpy_s(dst, max_amount, src)
        "_mbscpy_s" // _mbscpy_s(dst, max_amount, src)
      ] and
    // exclude the 2-parameter template versions
    // that find the size of a fixed size destination buffer.
    getNumberOfParameters() = 3
  }

  /**
   * Holds if this is one of the `strcpy_s` variants.
   */
  private predicate isSVariant() {
    exists(string name | name = getName() | name.suffix(name.length() - 2) = "_s")
  }

  /**
   * Gets the index of the parameter that is the maximum size of the copy (in characters).
   */
  int getParamSize() {
    if isSVariant()
    then result = 1
    else
      if exists(getName().indexOf("ncpy"))
      then result = 2
      else none()
  }

  /**
   * Gets the index of the parameter that is the source of the copy.
   */
  int getParamSrc() { if isSVariant() then result = 2 else result = 1 }

  /**
   * Gets the index of the parameter that is the destination of the copy.
   */
  int getParamDest() { result = 0 }

  override predicate hasArrayInput(int bufParam) { bufParam = getParamSrc() }

  override predicate hasArrayOutput(int bufParam) { bufParam = getParamDest() }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = getParamSrc() }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    bufParam = getParamDest() and
    countParam = getParamSize()
  }

  override predicate hasArrayWithUnknownSize(int bufParam) {
    not exists(getParamSize()) and
    bufParam = getParamDest()
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    not exists(getParamSize()) and
    input.isParameterDeref(getParamSrc()) and
    output.isParameterDeref(getParamDest())
    or
    not exists(getParamSize()) and
    input.isParameterDeref(getParamSrc()) and
    output.isReturnValueDeref()
    or
    input.isParameter(getParamDest()) and
    output.isReturnValue()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // these may do only a partial copy of the input buffer to the output
    // buffer
    exists(getParamSize()) and
    input.isParameter(getParamSrc()) and
    (
      output.isParameterDeref(getParamDest()) or
      output.isReturnValueDeref()
    )
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = getParamDest() and
    buffer = true and
    mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = getParamSrc() and
    buffer = true
  }

  override ParameterIndex getParameterSizeIndex(ParameterIndex i) {
    i = getParamDest() and
    result = getParamSize()
  }
}
