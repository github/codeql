/**
 * Provides implementation classes modeling `sscanf`, `fscanf` and various similar
 * functions. See `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.commons.Scanf
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The standard function `sscanf`, `fscanf` and its assorted variants
 */
private class SscanfModel extends ArrayFunction, TaintFunction, AliasFunction, SideEffectFunction {
  SscanfModel() { this instanceof Sscanf or this instanceof Fscanf or this instanceof Snscanf }

  override predicate hasArrayWithNullTerminator(int bufParam) {
    bufParam = this.(ScanfFunction).getFormatParameterIndex()
    or
    not this instanceof Fscanf and
    bufParam = this.(ScanfFunction).getInputParameterIndex()
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

  private int getArgsStartPosition() { result = this.getNumberOfParameters() }

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
