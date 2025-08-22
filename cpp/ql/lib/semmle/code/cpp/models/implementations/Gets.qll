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
 * The standard functions `fgets` and `fgetws`.
 */
private class FgetsFunction extends DataFlowFunction, TaintFunction, ArrayFunction, AliasFunction,
  SideEffectFunction, RemoteFlowSourceFunction
{
  FgetsFunction() {
    // fgets(str, num, stream)
    // fgetws(wstr, num, stream)
    this.hasGlobalOrStdOrBslName(["fgets", "fgetws"])
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isParameterDeref(2) }

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
    (
      output.isParameterDeref(0) or
      output.isReturnValueDeref()
    ) and
    description = "string read by " + this.getName()
  }

  override predicate hasArrayWithVariableSize(int bufParam, int countParam) {
    bufParam = 0 and
    countParam = 1
  }

  override predicate hasArrayOutput(int bufParam) { bufParam = 0 }

  override predicate hasSocketInput(FunctionInput input) { input.isParameterDeref(2) }
}

/**
 * The standard functions `gets`.
 */
private class GetsFunction extends DataFlowFunction, ArrayFunction, AliasFunction,
  SideEffectFunction, LocalFlowSourceFunction
{
  GetsFunction() {
    // gets(str)
    this.hasGlobalOrStdOrBslName("gets")
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isReturnValue()
  }

  override predicate parameterNeverEscapes(int index) { none() }

  override predicate parameterEscapesOnlyViaReturn(int index) { index = 0 }

  override predicate parameterIsAlwaysReturned(int index) { index = 0 }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 0 and
    buffer = true and
    mustWrite = true
  }

  override predicate hasLocalFlowSource(FunctionOutput output, string description) {
    (
      output.isParameterDeref(0) or
      output.isReturnValueDeref()
    ) and
    description = "string read by " + this.getName()
  }

  override predicate hasArrayWithUnknownSize(int bufParam) { bufParam = 0 }

  override predicate hasArrayOutput(int bufParam) { bufParam = 0 }
}

/**
 * A model for `getc` and similar functions that are flow sources.
 */
private class GetcSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;getc;;;ReturnValue;remote", ";;false;getwc;;;ReturnValue;remote",
        ";;false;_getc_nolock;;;ReturnValue;remote", ";;false;_getwc_nolock;;;ReturnValue;remote",
        ";;false;getch;;;ReturnValue;local", ";;false;_getch;;;ReturnValue;local",
        ";;false;_getwch;;;ReturnValue;local", ";;false;_getch_nolock;;;ReturnValue;local",
        ";;false;_getwch_nolock;;;ReturnValue;local", ";;false;getchar;;;ReturnValue;local",
        ";;false;getwchar;;;ReturnValue;local", ";;false;_getchar_nolock;;;ReturnValue;local",
        ";;false;_getwchar_nolock;;;ReturnValue;local",
      ]
  }
}
