/**
 * Provides implementation classes modeling `_strinc`, `_strdec` and their variants.
 * See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The function `_strinc`, `_strdec` and their variants.
 */
private class Strcrement extends ArrayFunction, TaintFunction, SideEffectFunction {
  Strcrement() {
    this.hasGlobalName([
        "_strinc", // _strinc(source, locale)
        "_wcsinc", // _strinc(source, locale)
        "_mbsinc", // _strinc(source)
        "_mbsinc_l", // _strinc(source, locale)
        "_strdec", // _strdec(start, source)
        "_wcsdec", // _wcsdec(start, source)
        "_mbsdec", // _mbsdec(start, source)
        "_mbsdec_l" // _mbsdec_l(start, source, locale)
      ])
  }

  override predicate hasArrayWithNullTerminator(int bufParam) {
    // Match all parameters that are not locales.
    this.getParameter(bufParam).getUnspecifiedType() instanceof PointerType
  }

  override predicate hasArrayInput(int bufParam) { this.hasArrayWithNullTerminator(bufParam) }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    exists(int index | this.hasArrayInput(index) |
      input.isParameter(index) and output.isReturnValue()
      or
      input.isParameterDeref(index) and output.isReturnValueDeref()
    )
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.hasArrayInput(i) and buffer = true
  }
}
