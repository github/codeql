/**
 * Provides implementation classes modeling `sscanf`, `fscanf` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The standard function `sscanf`, `fscanf` and its assorted variants
 */
private class Sscanf extends ArrayFunction, TaintFunction, AliasFunction, SideEffectFunction {
  Sscanf() {
    this.hasGlobalOrStdName([
        "sscanf", // sscanf(src_stream, format, args...)
        "swscanf", // swscanf(src, format, args...)
        "fscanf", // fscanf(src_stream, format, args...)
        "fwscanf" // fwscanf(src_stream, format, args...)
      ]) or
    this.hasGlobalName([
        "_sscanf_l", // _sscanf_l(src, format, locale, args...)
        "_swscanf_l", // _swscanf_l(src, format, locale, args...)
        "_snscanf", // _snscanf(src, length, format, args...)
        "_snscanf_l", // _snscanf_l(src, length, format, locale, args...)
        "_snwscanf", // _snwscanf(src, length, format, args...)
        "_snwscanf_l", // _snwscanf_l(src, length, format, locale, args...)
        "_fscanf_l", // _fscanf_l(src_stream, format, locale, args...)
        "_fwscanf_l" // _fwscanf_l(src_stream, format, locale, args...)
      ])
  }

  override predicate hasArrayWithNullTerminator(int bufParam) {
    bufParam = [0, getFormatPosition()]
  }

  override predicate hasArrayInput(int bufParam) { bufParam = [0, getFormatPosition()] }

  private int getLengthPosition() {
    this.getName().matches("\\_sn%") and
    result = 1
  }

  private int getLocalePosition() {
    this.getName().matches("%\\_l") and
    (if exists(getLengthPosition()) then result = getLengthPosition() + 2 else result = 2)
  }

  private int getFormatPosition() { if exists(getLengthPosition()) then result = 2 else result = 1 }

  private int getArgsStartPosition() {
    exists(int nLength, int nLocale |
      (if exists(getLocalePosition()) then nLocale = 1 else nLocale = 0) and
      (if exists(getLengthPosition()) then nLength = 1 else nLength = 0) and
      result = 2 + nLocale + nLength
    )
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isParameterDeref(any(int i | i >= getArgsStartPosition()))
  }

  override predicate parameterNeverEscapes(int index) {
    index = [0 .. max(getACallToThisFunction().getNumberOfArguments())]
  }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i >= getArgsStartPosition() and
    buffer = true and
    mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    buffer = true and
    i = [0, getFormatPosition(), getLocalePosition()]
  }
}
