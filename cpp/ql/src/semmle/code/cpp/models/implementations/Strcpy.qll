import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The standard function `strcpy` and its wide, sized, and Microsoft variants.
 */
class StrcpyFunction extends ArrayFunction, DataFlowFunction, TaintFunction, SideEffectFunction {
  StrcpyFunction() {
    exists(string name | name = getName() |
      // strcpy(dst, src)
      name = "strcpy"
      or
      // wcscpy(dst, src)
      name = "wcscpy"
      or
      // _mbscpy(dst, src)
      name = "_mbscpy"
      or
      (
        name = "strcpy_s" or // strcpy_s(dst, max_amount, src)
        name = "wcscpy_s" or // wcscpy_s(dst, max_amount, src)
        name = "_mbscpy_s" // _mbscpy_s(dst, max_amount, src)
      ) and
      // exclude the 2-parameter template versions
      // that find the size of a fixed size destination buffer.
      getNumberOfParameters() = 3
      or
      // strncpy(dst, src, max_amount)
      name = "strncpy"
      or
      // _strncpy_l(dst, src, max_amount, locale)
      name = "_strncpy_l"
      or
      // wcsncpy(dst, src, max_amount)
      name = "wcsncpy"
      or
      // _wcsncpy_l(dst, src, max_amount, locale)
      name = "_wcsncpy_l"
      or
      // _mbsncpy(dst, src, max_amount)
      name = "_mbsncpy"
      or
      // _mbsncpy_l(dst, src, max_amount, locale)
      name = "_mbsncpy_l"
    )
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
