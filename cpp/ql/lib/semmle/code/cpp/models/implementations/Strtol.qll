import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

private string strtol() { result = ["strtod", "strtof", "strtol", "strtoll", "strtoq", "strtoul"] }

/**
 * The standard function `strtol` and its assorted variants
 */
private class Strtol extends AliasFunction, ArrayFunction, TaintFunction, SideEffectFunction {
  Strtol() { this.hasGlobalOrStdOrBslName(strtol()) }

  override predicate hasArrayInput(int bufParam) {
    // All the functions given by `strtol()` takes a `const char*` input as the first parameter
    bufParam = 0
  }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    (
      input.isParameter(0)
      or
      input.isParameterDeref(0)
    ) and
    output.isReturnValue()
    or
    input.isParameter(0) and
    output.isParameterDeref(1)
  }

  override predicate parameterNeverEscapes(int i) {
    // Parameter 0 does escape into parameter 1.
    i = 1
  }

  override predicate parameterEscapesOnlyViaReturn(int i) { none() }

  override predicate parameterIsAlwaysReturned(int i) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 0 and
    buffer = true
  }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 1 and buffer = false and mustWrite = false
  }
}
