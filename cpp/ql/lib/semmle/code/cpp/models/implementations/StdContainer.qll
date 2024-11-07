/**
 * Provides models for C++ containers `std::array`, `std::vector`, `std::deque`, `std::list` and `std::forward_list`.
 */

import semmle.code.cpp.models.interfaces.FlowSource
import semmle.code.cpp.models.interfaces.Iterator
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.Alias

/**
 * A sequence container template class (for example, `std::vector`) from the
 * standard library.
 */
abstract class StdSequenceContainer extends Class {
  Type getElementType() { result = this.getTemplateArgument(0) }
}

/**
 * The `std::array` template class.
 */
private class Array extends StdSequenceContainer {
  Array() { this.hasQualifiedName(["std", "bsl"], "array") }
}

/**
 * The `std::string` template class.
 */
private class String extends StdSequenceContainer {
  String() { this.hasQualifiedName(["std", "bsl"], "basic_string") }
}

/**
 * The `std::deque` template class.
 */
private class Deque extends StdSequenceContainer {
  Deque() { this.hasQualifiedName(["std", "bsl"], "deque") }
}

/**
 * The `std::forward_list` template class.
 */
private class ForwardList extends StdSequenceContainer {
  ForwardList() { this.hasQualifiedName(["std", "bsl"], "forward_list") }
}

/**
 * The `std::list` template class.
 */
private class List extends StdSequenceContainer {
  List() { this.hasQualifiedName(["std", "bsl"], "list") }
}

/**
 * The `std::vector` template class.
 */
private class Vector extends StdSequenceContainer {
  Vector() { this.hasQualifiedName(["std", "bsl"], "vector") }
}

/**
 * The standard container functions `push_back` and `push_front`.
 */
class StdSequenceContainerPush extends MemberFunction, SideEffectFunction, AliasFunction {
  StdSequenceContainerPush() {
    this.getClassAndName("push_back") instanceof Vector or
    this.getClassAndName(["push_back", "push_front"]) instanceof Deque or
    this.getClassAndName("push_front") instanceof ForwardList or
    this.getClassAndName(["push_back", "push_front"]) instanceof List
  }

  /**
   * Gets the index of a parameter to this function that is a reference to the
   * value type of the container.
   */
  int getAValueTypeParameterIndex() {
    this.getParameter(result).getUnspecifiedType().(ReferenceType).getBaseType() =
      this.getDeclaringType().getTemplateArgument(0).(Type).getUnspecifiedType() // i.e. the `T` of this `std::vector<T>`
  }

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
    // the `std::vector<bool>` specialization doesn't take a reference as a
    // parameter. So we need to check that the parameter is actually a
    // reference.
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and
    buffer = false
  }
}

private class StdSequenceContainerPopFrontOrBack extends MemberFunction, SideEffectFunction,
  AliasFunction
{
  StdSequenceContainerPopFrontOrBack() {
    this.getClassAndName("pop_back") instanceof Vector or
    this.getClassAndName("pop_front") instanceof ForwardList or
    this.getClassAndName(["pop_front", "pop_back"]) instanceof Deque or
    this.getClassAndName(["pop_front", "pop_back"]) instanceof List
  }

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

private class StdSequenceContainerClear extends MemberFunction, SideEffectFunction, AliasFunction {
  StdSequenceContainerClear() {
    this.getClassAndName("clear") instanceof Vector or
    this.getClassAndName("clear") instanceof Deque or
    this.getClassAndName("clear") instanceof ForwardList or
    this.getClassAndName("clear") instanceof List
  }

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

private class StdVectorReserve extends MemberFunction, SideEffectFunction, AliasFunction {
  StdVectorReserve() { this.getClassAndName("reserve") instanceof Vector }

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

/**
 * The standard container functions `insert` and `insert_after`.
 */
class StdSequenceContainerInsert extends MemberFunction, SideEffectFunction, AliasFunction {
  StdSequenceContainerInsert() {
    this.getClassAndName("insert") instanceof Deque or
    this.getClassAndName("insert") instanceof List or
    this.getClassAndName("insert") instanceof Vector or
    this.getClassAndName("insert_after") instanceof ForwardList
  }

  /**
   * Gets the index of a parameter to this function that is a reference to the
   * value type of the container.
   */
  int getAValueTypeParameterIndex() {
    this.getParameter(result).getUnspecifiedType().(ReferenceType).getBaseType() =
      this.getDeclaringType().getTemplateArgument(0).(Type).getUnspecifiedType() // i.e. the `T` of this `std::vector<T>`
  }

  /**
   * Gets the index of a parameter to this function that is an iterator.
   */
  int getAnIteratorParameterIndex() { this.getParameter(result).getType() instanceof Iterator }

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
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and
    buffer = false
  }
}

private class StdSequenceContainerFrontBack extends MemberFunction, SideEffectFunction,
  AliasFunction
{
  StdSequenceContainerFrontBack() {
    this.getClassAndName(["front", "back"]) instanceof Deque or
    this.getClassAndName(["front", "back"]) instanceof List or
    this.getClassAndName(["front", "back"]) instanceof Vector or
    // forward_list does not have a 'back' member function
    this.getClassAndName("front") instanceof ForwardList
  }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }
}

/**
 * The standard container functions `at` and `operator[]`.
 */
class StdSequenceContainerAt extends MemberFunction, SideEffectFunction, AliasFunction {
  StdSequenceContainerAt() {
    this.getClassAndName(["at", "operator[]"]) instanceof Array or
    this.getClassAndName(["at", "operator[]"]) instanceof Deque or
    this.getClassAndName(["at", "operator[]"]) instanceof Vector
  }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    none()
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }
}

private class StdSequenceContainerMemberEquals extends MemberFunction, SideEffectFunction,
  AliasFunction
{
  StdSequenceContainerMemberEquals() {
    this.getClassAndName("operator==") instanceof Array or
    this.getClassAndName("operator==") instanceof Deque or
    this.getClassAndName("operator==") instanceof Vector
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate parameterNeverEscapes(int index) { index = -1 or index = 0 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    none()
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
    or
    i = 0 and buffer = false
  }
}

private class StdSequenceContainerEquals extends Function, SideEffectFunction, AliasFunction {
  StdSequenceContainerEquals() {
    this.hasGlobalOrStdOrBslName("operator==") and
    not this instanceof MemberFunction and
    this.getNumberOfParameters() = 2 and
    (
      this.getParameter(0).getUnspecifiedType().(ReferenceType).getBaseType() instanceof Vector and
      this.getParameter(1).getUnspecifiedType().(ReferenceType).getBaseType() instanceof Vector
      or
      this.getParameter(0).getUnspecifiedType().(ReferenceType).getBaseType() instanceof List and
      this.getParameter(1).getUnspecifiedType().(ReferenceType).getBaseType() instanceof List
      or
      this.getParameter(0).getUnspecifiedType().(ReferenceType).getBaseType() instanceof Deque and
      this.getParameter(1).getUnspecifiedType().(ReferenceType).getBaseType() instanceof Deque
    )
  }

  override predicate parameterNeverEscapes(int index) { index = 0 or index = 1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    none()
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = [0, 1] and buffer = false
  }
}

/**
 * The standard `emplace` function.
 */
class StdSequenceEmplace extends MemberFunction {
  StdSequenceEmplace() {
    this.getClassAndName("emplace") instanceof Vector
    or
    this.getClassAndName("emplace") instanceof List
    or
    this.getClassAndName("emplace") instanceof Deque
  }

  /**
   * Gets the index of a parameter to this function that is a reference to the
   * value type of the container.
   */
  int getAValueTypeParameterIndex() {
    this.getParameter(result).getUnspecifiedType().(ReferenceType).getBaseType() =
      this.getDeclaringType().getTemplateArgument(0).(Type).getUnspecifiedType() // i.e. the `T` of this `std::vector<T>`
  }
}

/**
 * The standard vector `emplace` function.
 */
class StdVectorEmplace extends StdSequenceEmplace {
  StdVectorEmplace() { this.getDeclaringType() instanceof Vector }
}

private class StdSequenceSize extends MemberFunction, SideEffectFunction, AliasFunction {
  StdSequenceSize() {
    this.getClassAndName("size") instanceof Vector
    or
    this.getClassAndName("size") instanceof List
    or
    this.getClassAndName("size") instanceof Deque
  }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }
}

private class StdSequenceDestructor extends Destructor, SideEffectFunction, AliasFunction {
  StdSequenceDestructor() {
    this.getDeclaringType() instanceof Vector
    or
    this.getDeclaringType() instanceof List
    or
    this.getDeclaringType() instanceof Deque
  }

  private Destructor getElementDestructor() {
    result.getDeclaringType() = this.getTemplateArgument(0)
  }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() {
    this.getElementDestructor().(SideEffectFunction).hasOnlySpecificReadSideEffects()
    or
    not exists(this.getElementDestructor())
  }

  override predicate hasOnlySpecificWriteSideEffects() {
    this.getElementDestructor().(SideEffectFunction).hasOnlySpecificWriteSideEffects()
    or
    not exists(this.getElementDestructor())
  }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }
}

private class StdSequenceConstructor extends Constructor, SideEffectFunction, AliasFunction {
  StdSequenceConstructor() {
    this.getDeclaringType() instanceof Vector
    or
    this.getDeclaringType() instanceof List
    or
    this.getDeclaringType() instanceof Deque
  }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and
    buffer = false
  }
}

private class InitializerList extends Class {
  InitializerList() { this.hasQualifiedName(["std", "bsl"], "initializer_list") }

  Type getElementType() { result = this.getTemplateArgument(0) }
}

private class InitializerListConstructor extends Constructor, SideEffectFunction, AliasFunction {
  InitializerListConstructor() { this.getDeclaringType() instanceof InitializerList }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }
}

/**
 * The standard vector `emplace_back` function.
 */
class StdSequenceEmplaceBack extends MemberFunction {
  StdSequenceEmplaceBack() {
    this.getClassAndName("emplace_back") instanceof Vector
    or
    this.getClassAndName("emplace_back") instanceof List
    or
    this.getClassAndName("emplace_back") instanceof Deque
  }

  /**
   * Gets the index of a parameter to this function that is a reference to the
   * value type of the container.
   */
  int getAValueTypeParameterIndex() {
    this.getParameter(result).getUnspecifiedType().(ReferenceType).getBaseType() =
      this.getDeclaringType().getTemplateArgument(0).(Type).getUnspecifiedType() // i.e. the `T` of this `std::vector<T>`
  }
}

/**
 * The standard vector `emplace_back` function.
 */
class StdVectorEmplaceBack extends StdSequenceEmplaceBack {
  StdVectorEmplaceBack() { this.getDeclaringType() instanceof Vector }
}
