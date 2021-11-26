/**
 * Provides implementation classes modeling `strset` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The standard function `strset` and its assorted variants
 */
private class StrsetFunction extends ArrayFunction, DataFlowFunction, AliasFunction,
  SideEffectFunction {
  StrsetFunction() {
    hasGlobalName([
        "strset", "_strset", "_strset_l", "_wcsset", "_wcsset_l", "_mbsset", "_mbsset_l",
        "_mbsnbset", "_mbsnbset_l", "_strnset", "_strnset_l", "_wcsnset", "_wcsnset_l", "_mbsnset",
        "_mbsnset_l"
      ])
  }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayOutput(int bufParam) { bufParam = 0 }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // flow from the character that overrides the string
    input.isParameter(1) and
    (
      output.isReturnValueDeref()
      or
      output.isParameterDeref(0)
    )
    or
    // flow from the input string to the output string
    input.isParameter(0) and
    output.isReturnValue()
  }

  override predicate parameterNeverEscapes(int index) { none() }

  override predicate parameterEscapesOnlyViaReturn(int index) { index = 0 }

  override predicate parameterIsAlwaysReturned(int index) { index = 0 }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 0 and buffer = true and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 0 and buffer = true
  }
}
