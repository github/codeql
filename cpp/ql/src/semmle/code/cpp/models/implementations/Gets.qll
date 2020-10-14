/**
 * Provides implementation classes modeling `gets` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.FlowSource

/**
 * The standard functions `gets` and `fgets`.
 */
class GetsFunction extends DataFlowFunction, TaintFunction, ArrayFunction, AliasFunction,
  SideEffectFunction, RemoteFlowFunction {
  GetsFunction() {
    // gets(str)
    // fgets(str, num, stream)
    // fgetws(wstr, num, stream)
    hasGlobalOrStdName(["gets", "fgets", "fgetws"])
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

  override predicate hasRemoteFlowSource(FunctionOutput output, string description) {
    output.isParameterDeref(0) and
    description = "String read by " + this.getName()
  }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    not hasGlobalOrStdName("gets") and
    bufParam = 0 and
    countParam = 1
  }

  override predicate hasArrayWithUnknownSize(int bufParam) {
    hasGlobalOrStdName("gets") and
    bufParam = 0
  }

  override predicate hasArrayOutput(int bufParam) { bufParam = 0 }
}
