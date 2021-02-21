/**
 * Provides implementation classes modeling `strtok` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.Taint

/**
 * The standard function `strtok` and its assorted variants
 */
private class Strtok extends ArrayFunction, AliasFunction, TaintFunction, SideEffectFunction {
  Strtok() {
    this.hasGlobalOrStdOrBslName("strtok") or
    this.hasGlobalName(["strtok_r", "_strtok_l", "wcstok", "_wcstok_l", "_mbstok", "_mbstok_l"])
  }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = [0, 1] }

  override predicate hasArrayInput(int bufParam) { bufParam = [0, 1] }

  override predicate hasArrayOutput(int bufParam) { bufParam = 0 }

  override predicate parameterNeverEscapes(int index) { index = 1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { index = 0 }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and output.isReturnValue()
  }

  override predicate hasOnlySpecificReadSideEffects() { none() }

  override predicate hasOnlySpecificWriteSideEffects() { none() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 0 and buffer = true and mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = [0, 1] and buffer = true
  }
}

/**
 * The function `strtok` is a variant of `strtok` that takes a `char**` parameter instead of
 * a `char*` as the first parameter.
 */
private class Strsep extends ArrayFunction, AliasFunction, TaintFunction, SideEffectFunction {
  Strsep() { this.hasGlobalName("strsep") }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 1 }

  override predicate hasArrayInput(int bufParam) { bufParam = 1 }

  override predicate parameterNeverEscapes(int index) { index = [0, 1] }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // NOTE: What we really want here is: (input.isParameterDerefDeref(0) or input.isParameterDeref(1))
    // as the first conjunct.
    input.isParameterDeref([0, 1]) and
    (output.isReturnValue() or output.isReturnValueDeref())
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 0 and buffer = false and mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 0 and buffer = false
    or
    i = 1 and buffer = true
  }
}
