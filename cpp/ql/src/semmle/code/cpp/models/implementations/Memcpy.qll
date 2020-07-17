/**
 * Provides implementation classes modeling `memcpy` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.Taint

/**
 * The standard functions `memcpy` and `memmove`, and the gcc variant
 * `__builtin___memcpy_chk`
 */
class MemcpyFunction extends ArrayFunction, DataFlowFunction, SideEffectFunction, TaintFunction {
  MemcpyFunction() {
    this.hasName("memcpy") or
    this.hasName("memmove") or
    this.hasName("__builtin___memcpy_chk")
  }

  override predicate hasArrayInput(int bufParam) { bufParam = 1 }

  override predicate hasArrayOutput(int bufParam) { bufParam = 0 }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(1) and
    output.isParameterDeref(0)
    or
    input.isParameterDeref(1) and
    output.isReturnValueDeref()
    or
    input.isParameter(0) and
    output.isReturnValue()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(2) and
    output.isParameterDeref(0)
    or
    input.isParameter(2) and
    output.isReturnValueDeref()
  }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    (
      bufParam = 0 or
      bufParam = 1
    ) and
    countParam = 2
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 0 and buffer = true and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 1 and buffer = true
  }

  override ParameterIndex getParameterSizeIndex(ParameterIndex i) {
    result = 2 and
    (
      i = 0 or
      i = 1
    )
  }
}
