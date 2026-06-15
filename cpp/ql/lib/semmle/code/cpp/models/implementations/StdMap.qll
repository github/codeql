/**
 * Provides models for C++ containers `std::map` and `std::unordered_map`.
 */

import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Iterator
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.Alias

/**
 * The `std::map` and `std::unordered_map` template classes.
 */
private class MapOrUnorderedMap extends Class {
  MapOrUnorderedMap() { this.hasQualifiedName(["std", "bsl"], ["map", "unordered_map"]) }
}

/**
 * Additional model for map constructors using iterator inputs.
 */
private class StdMapConstructor extends Constructor, TaintFunction, AliasFunction,
  SideEffectFunction
{
  StdMapConstructor() { this.getDeclaringType() instanceof MapOrUnorderedMap }

  /**
   * Gets the index of a parameter to this function that is an iterator.
   */
  int getAnIteratorParameterIndex() {
    this.getParameter(result).getUnspecifiedType() instanceof Iterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from any parameter of an iterator type to the qualifier
    input.isParameterDeref(this.getAnIteratorParameterIndex()) and
    (
      output.isReturnValue() // TODO: this is only needed for AST data flow, which treats constructors as returning the new object
      or
      output.isQualifierObject()
    )
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and
    buffer = false
  }
}

/**
 * The standard map `insert` and `insert_or_assign` functions.
 */
private class StdMapInsert extends TaintFunction {
  StdMapInsert() {
    this.getClassAndName(["insert", "insert_or_assign"]) instanceof MapOrUnorderedMap
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from last parameter to qualifier and return value
    // (where the return value is a pair, this should really flow just to the first part of it)
    input.isParameterDeref(this.getNumberOfParameters() - 1) and
    (
      output.isQualifierObject() or
      output.isReturnValue()
    )
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }
}

/**
 * The standard map `emplace` and `emplace_hint` functions.
 */
private class StdMapEmplace extends TaintFunction {
  StdMapEmplace() { this.getClassAndName(["emplace", "emplace_hint"]) instanceof MapOrUnorderedMap }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from the last parameter (which may be the value part used to
    // construct a pair, or a pair to be copied / moved) to the qualifier and
    // return value.
    // (where the return value is a pair, this should really flow just to the first part of it)
    input.isParameterDeref(this.getNumberOfParameters() - 1) and
    (
      output.isQualifierObject() or
      output.isReturnValue()
    )
    or
    input.isQualifierObject() and
    output.isReturnValue()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }
}

/**
 * The standard map `try_emplace` function.
 */
private class StdMapTryEmplace extends TaintFunction {
  StdMapTryEmplace() { this.getClassAndName("try_emplace") instanceof MapOrUnorderedMap }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from any parameter apart from the key to qualifier and return value
    // (here we assume taint flow from any constructor parameter to the constructed object)
    // (where the return value is a pair, this should really flow just to the first part of it)
    exists(int arg | arg = [1 .. this.getNumberOfParameters() - 1] |
      (
        not this.getUnspecifiedType() instanceof Iterator or
        arg != 1
      ) and
      input.isParameterDeref(arg)
    ) and
    (
      output.isQualifierObject() or
      output.isReturnValue()
    )
    or
    input.isQualifierObject() and
    output.isReturnValue()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }
}

/**
 * The standard map `merge` function.
 */
private class StdMapMerge extends TaintFunction {
  StdMapMerge() { this.getClassAndName("merge") instanceof MapOrUnorderedMap }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // container1.merge(container2)
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }
}

/**
 * The standard map functions `at` and `operator[]`.
 */
class StdMapAt extends MemberFunction {
  StdMapAt() { this.getClassAndName(["at", "operator[]"]) instanceof MapOrUnorderedMap }
}

private class StdMapAtModels extends StdMapAt, TaintFunction, AliasFunction, SideEffectFunction {
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to referenced return value
    input.isQualifierObject() and
    output.isReturnValueDeref()
    or
    // reverse flow from returned reference to the qualifier
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }
}

/**
 * The standard map `find` function.
 */
private class StdMapFind extends TaintFunction {
  StdMapFind() { this.getClassAndName("find") instanceof MapOrUnorderedMap }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * The standard map `erase` function.
 */
private class StdMapErase extends TaintFunction {
  StdMapErase() { this.getClassAndName("erase") instanceof MapOrUnorderedMap }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to iterator return value
    this.getType().getUnderlyingType() instanceof Iterator and
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * The standard map `lower_bound`, `upper_bound` and `equal_range` functions.
 */
private class StdMapEqualRange extends TaintFunction {
  StdMapEqualRange() {
    this.getClassAndName(["lower_bound", "upper_bound", "equal_range"]) instanceof MapOrUnorderedMap
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to return value
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

class StdMapDestructor extends Destructor, SideEffectFunction, AliasFunction {
  StdMapDestructor() { this.getDeclaringType() instanceof MapOrUnorderedMap }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }
}

private class StdMapClear extends MemberFunction, SideEffectFunction, AliasFunction {
  StdMapClear() { this.getClassAndName("clear") instanceof MapOrUnorderedMap }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and
    buffer = false and
    mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and
    buffer = false
  }
}

class StdMapSize extends MemberFunction, SideEffectFunction, AliasFunction {
  StdMapSize() { this.getClassAndName("size") instanceof MapOrUnorderedMap }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and
    buffer = false
  }
}
