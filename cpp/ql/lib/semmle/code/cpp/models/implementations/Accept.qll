/**
 * Provides implementation classes modeling `accept` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The function `accept` and its assorted variants
 */
private class Accept extends ArrayFunction, AliasFunction, TaintFunction, SideEffectFunction {
  Accept() { this.hasGlobalName(["accept", "accept4", "WSAAccept"]) }

  override predicate hasArrayWithUnknownSize(int bufParam) { bufParam = 1 }

  override predicate hasArrayInput(int bufParam) { bufParam = 1 }

  override predicate hasArrayOutput(int bufParam) { bufParam = 1 }

  override predicate parameterNeverEscapes(int index) { exists(this.getParameter(index)) }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (input.isParameter(0) or input.isParameterDeref(1)) and
    (output.isReturnValue() or output.isParameterDeref(1))
  }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 1 and buffer = true and mustWrite = false
    or
    i = 2 and buffer = false and mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 0 and buffer = true
    or
    i = 1 and buffer = false
  }

  // NOTE: The size parameter is a pointer to the size. So we can't implement `getParameterSizeIndex` for
  // this model.
  // NOTE: We implement thse two predicates as none because we can't model the low-level changes made to
  // the structure pointed to by the file-descriptor argument.
  override predicate hasOnlySpecificReadSideEffects() { none() }

  override predicate hasOnlySpecificWriteSideEffects() { none() }
}
