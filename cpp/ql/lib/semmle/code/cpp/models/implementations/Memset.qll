/**
 * Provides implementation classes modeling `memset` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.NonThrowing

private class MemsetFunctionModel extends ArrayFunction, DataFlowFunction, AliasFunction,
  SideEffectFunction, NonCppThrowingFunction
{
  MemsetFunctionModel() {
    this.hasGlobalOrStdOrBslName("memset")
    or
    this.hasGlobalOrStdName("wmemset")
    or
    this.hasGlobalName([
        bzero(), "__builtin_memset", "__builtin_memset_chk", "RtlZeroMemory", "RtlSecureZeroMemory"
      ])
  }

  /**
   * Gets the index of the parameter that specifies the fill character to insert, if any.
   */
  private int getFillCharParameterIndex() {
    (
      this.hasGlobalOrStdOrBslName("memset")
      or
      this.hasGlobalOrStdName("wmemset")
      or
      this.hasGlobalName(["__builtin_memset", "__builtin_memset_chk"])
    ) and
    result = 1
  }

  override predicate hasArrayOutput(int bufParam) { bufParam = 0 }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
    or
    input.isParameter(this.getFillCharParameterIndex()) and
    (output.isParameterDeref(0) or output.isReturnValueDeref())
  }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    bufParam = 0 and
    (if this.hasGlobalName(bzero()) then countParam = 1 else countParam = 2)
  }

  override predicate parameterNeverEscapes(int index) { this.hasGlobalName(bzero()) and index = 0 }

  override predicate parameterEscapesOnlyViaReturn(int index) {
    not this.hasGlobalName(bzero()) and index = 0
  }

  override predicate parameterIsAlwaysReturned(int index) {
    not this.hasGlobalName(bzero()) and index = 0
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 0 and buffer = true and mustWrite = true
  }

  override ParameterIndex getParameterSizeIndex(ParameterIndex i) {
    i = 0 and
    if this.hasGlobalName(bzero()) then result = 1 else result = 2
  }
}

private string bzero() { result = ["bzero", "explicit_bzero"] }

/**
 * The standard function `memset` and its assorted variants
 */
class MemsetFunction extends Function instanceof MemsetFunctionModel { }
