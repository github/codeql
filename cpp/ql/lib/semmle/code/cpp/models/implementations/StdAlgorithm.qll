/**
 * Provides models for C++ functions from the `algorithms` header.
 */

import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Iterator
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.Alias

private class StdPartialSort extends Function, SideEffectFunction, AliasFunction {
  StdPartialSort() { this.hasGlobalOrStdName("partial_sort") }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = this.getAnIteratorParameterIndex() and buffer = true and mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = this.getAnIteratorParameterIndex() and
    buffer = true and
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and
    buffer = false
  }

  private int getAnIteratorParameterIndex() {
    this.getParameter(result).getUnspecifiedType() instanceof Iterator
  }

  override predicate parameterNeverEscapes(int index) {
    index = this.getAnIteratorParameterIndex()
    or
    this.getParameter(index).getUnspecifiedType() instanceof ReferenceType
  }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }
}

private class StdSortHeap extends Function, SideEffectFunction, AliasFunction {
  StdSortHeap() { this.hasGlobalOrStdName("sort_heap") }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = this.getAnIteratorParameterIndex() and buffer = true and mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = this.getAnIteratorParameterIndex() and
    buffer = true
  }

  private int getAnIteratorParameterIndex() {
    this.getParameter(result).getUnspecifiedType() instanceof Iterator
  }

  override predicate parameterNeverEscapes(int index) { index = this.getAnIteratorParameterIndex() }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }
}

private class StdGenerateN extends Function, SideEffectFunction, AliasFunction {
  StdGenerateN() { this.hasGlobalOrStdName("generate_n") }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = this.getAnIteratorParameterIndex() and buffer = true and mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and buffer = false
  }

  private int getAnIteratorParameterIndex() {
    this.getParameter(result).getUnspecifiedType() instanceof Iterator
  }

  override predicate parameterNeverEscapes(int index) { index = this.getAnIteratorParameterIndex() }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }
}

private class StdFindIfOrIfNot extends Function, SideEffectFunction, AliasFunction {
  StdFindIfOrIfNot() { this.hasGlobalOrStdName(["find_if", "find_if_not"]) }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = this.getAnIteratorParameterIndex() and buffer = true
    or
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and buffer = false
  }

  private int getAnIteratorParameterIndex() {
    this.getParameter(result).getUnspecifiedType() instanceof Iterator
  }

  override predicate parameterNeverEscapes(int index) {
    this.getParameter(index).getUnspecifiedType() instanceof ReferenceType
  }

  override predicate parameterEscapesOnlyViaReturn(int index) {
    index = this.getAnIteratorParameterIndex()
  }
}
