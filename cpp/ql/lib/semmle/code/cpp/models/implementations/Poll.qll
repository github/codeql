/**
 * Provides implementation classes modeling `poll` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The function `poll` and its assorted variants
 */
private class Poll extends ArrayFunction, AliasFunction, SideEffectFunction {
  Poll() { this.hasGlobalName(["poll", "ppoll", "WSAPoll"]) }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    bufParam = 0 and countParam = 1
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 }

  override predicate hasArrayOutput(int bufParam) { bufParam = 0 }

  override predicate parameterNeverEscapes(int index) { exists(this.getParameter(index)) }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 0 and buffer = true and mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 0 and buffer = true
    or
    this.hasGlobalName("ppoll") and i = [2, 3] and buffer = false
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}
