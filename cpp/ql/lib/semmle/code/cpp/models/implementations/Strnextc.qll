/**
 * Provides implementation classes modeling `strnextc` and various similar functions.
 * See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The function `strnextc` and its variants.
 */
private class Strnextc extends TaintFunction, ArrayFunction, AliasFunction, SideEffectFunction {
  Strnextc() { this.hasGlobalName(["_strnextc", "_wcsnextc", "_mbsnextc", "_mbsnextc_l"]) }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and output.isReturnValue()
  }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate parameterNeverEscapes(int index) { index = 0 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 0 and buffer = true
  }
}
