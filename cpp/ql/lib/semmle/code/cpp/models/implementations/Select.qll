/**
 * Provides implementation classes modeling `select` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The function `select` and its assorted variants
 */
private class Select extends ArrayFunction, AliasFunction, SideEffectFunction {
  Select() { this.hasGlobalName(["select", "pselect"]) }

  override predicate hasArrayWithUnknownSize(int bufParam) { bufParam = [1 .. 3] }

  override predicate hasArrayInput(int bufParam) { bufParam = [1 .. 3] }

  override predicate hasArrayOutput(int bufParam) { bufParam = [1 .. 3] }

  override predicate parameterNeverEscapes(int index) { exists(this.getParameter(index)) }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = [1 .. 3] and buffer = true and mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = [1 .. 5] and buffer = true
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}
