/**
 * Provides implementation classes modeling the `scanf` family of functions.
 * See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.commons.Scanf
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.FlowSource

/**
 * The `scanf` family of functions.
 */
abstract private class ScanfFunctionModel extends ArrayFunction, TaintFunction, AliasFunction,
  SideEffectFunction
{
  override predicate hasArrayWithNullTerminator(int bufParam) {
    bufParam = this.(ScanfFunction).getFormatParameterIndex()
  }

  override predicate hasArrayInput(int bufParam) { this.hasArrayWithNullTerminator(bufParam) }

  private int getLengthParameterIndex() { result = this.(Snscanf).getInputLengthParameterIndex() }

  private int getLocaleParameterIndex() {
    this.getName().matches("%\\_l") and
    (
      if exists(this.getLengthParameterIndex())
      then result = this.getLengthParameterIndex() + 2
      else result = 2
    )
  }

  int getArgsStartPosition() { result = this.getNumberOfParameters() }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(this.(ScanfFunction).getInputParameterIndex()) and
    output.isParameterDeref(any(int i | i >= this.getArgsStartPosition()))
  }

  override predicate parameterNeverEscapes(int index) {
    index = [0 .. max(this.getACallToThisFunction().getNumberOfArguments())]
  }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i >= this.getArgsStartPosition() and
    buffer = true and
    mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    buffer = true and
    i =
      [
        this.(ScanfFunction).getInputParameterIndex(),
        this.(ScanfFunction).getFormatParameterIndex(), this.getLocaleParameterIndex()
      ]
  }
}

/**
 * The standard function `scanf` and its assorted variants
 */
private class ScanfModel extends ScanfFunctionModel, LocalFlowSourceFunction instanceof Scanf {
  override predicate hasLocalFlowSource(FunctionOutput output, string description) {
    output.isParameterDeref(any(int i | i >= this.getArgsStartPosition())) and
    description = "value read by " + this.getName()
  }
}

/**
 * The standard function `fscanf` and its assorted variants
 */
private class FscanfModel extends ScanfFunctionModel, RemoteFlowSourceFunction instanceof Fscanf {
  override predicate hasRemoteFlowSource(FunctionOutput output, string description) {
    output.isParameterDeref(any(int i | i >= this.getArgsStartPosition())) and
    description = "value read by " + this.getName()
  }
}

/**
 * The standard function `sscanf` and its assorted variants
 */
private class SscanfModel extends ScanfFunctionModel {
  SscanfModel() { this instanceof Sscanf or this instanceof Snscanf }

  override predicate hasArrayWithNullTerminator(int bufParam) {
    super.hasArrayWithNullTerminator(bufParam)
    or
    bufParam = this.(ScanfFunction).getInputParameterIndex()
  }
}
