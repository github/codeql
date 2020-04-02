import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The standard functions `gets` and `fgets`.
 */
class GetsFunction extends DataFlowFunction, TaintFunction, ArrayFunction, AliasFunction,
  SideEffectFunction {
  GetsFunction() {
    exists(string name | hasGlobalOrStdName(name) |
      name = "gets" or // gets(str)
      name = "fgets" or // fgets(str, num, stream)
      name = "fgetws" // fgetws(wstr, num, stream)
    )
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(2) and
    output.isParameterDeref(0)
  }

  override predicate parameterNeverEscapes(int index) { index = 2 }

  override predicate parameterEscapesOnlyViaReturn(int index) { index = 0 }

  override predicate parameterIsAlwaysReturned(int index) { index = 0 }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 0 and
    buffer = true and
    mustWrite = true
  }
}
