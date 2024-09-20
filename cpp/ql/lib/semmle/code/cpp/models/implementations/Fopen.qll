/**
 * Provides implementation classes modeling `fopen` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/** The function `fopen` and friends. */
private class Fopen extends Function, AliasFunction, SideEffectFunction {
  Fopen() {
    this.hasGlobalOrStdName(["fopen", "fopen_s", "freopen"])
    or
    this.hasGlobalName(["_open", "_wfopen", "_fsopen", "_wfsopen", "_wopen"])
  }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate parameterEscapesOnlyViaReturn(int i) { none() }

  override predicate parameterNeverEscapes(int index) {
    // None of the parameters escape
    this.getParameter(index).getUnspecifiedType() instanceof PointerType
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    (
      this.hasGlobalOrStdName(["fopen", "fopen_s"])
      or
      this.hasGlobalName(["_wfopen", "_fsopen", "_wfsopen"])
    ) and
    i = [0, 1] and
    buffer = true
    or
    this.hasGlobalOrStdName("freopen") and
    (
      i = [0, 1] and
      buffer = true
      or
      i = 2 and
      buffer = false
    )
    or
    this.hasGlobalName(["_open", "_wopen"]) and
    i = 0 and
    buffer = true
  }
}
