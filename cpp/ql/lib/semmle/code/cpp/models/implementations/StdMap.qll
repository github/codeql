/**
 * Provides models for C++ containers `std::map` and `std::unordered_map`.
 */

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
private class StdMapConstructor extends Constructor, AliasFunction, SideEffectFunction {
  StdMapConstructor() { this.getDeclaringType() instanceof MapOrUnorderedMap }

  /**
   * Gets the index of a parameter to this function that is an iterator.
   */
  int getAnIteratorParameterIndex() {
    this.getParameter(result).getUnspecifiedType() instanceof Iterator
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
 * The standard map functions `at` and `operator[]`.
 */
class StdMapAt extends MemberFunction {
  StdMapAt() { this.getClassAndName(["at", "operator[]"]) instanceof MapOrUnorderedMap }
}

private class StdMapAtModels extends StdMapAt, AliasFunction, SideEffectFunction {
  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
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
