/**
 * Provides models for C++ containers `std::array`, `std::vector`, `std::deque`, `std::list` and `std::forward_list`.
 */

import semmle.code.cpp.models.interfaces.FlowSource
import semmle.code.cpp.models.interfaces.Iterator

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
class StdSequenceContainerPush extends MemberFunction {
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
}

/**
 * The standard container functions `insert` and `insert_after`.
 */
class StdSequenceContainerInsert extends MemberFunction {
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
}

/**
 * The standard container functions `at` and `operator[]`.
 */
class StdSequenceContainerAt extends MemberFunction {
  StdSequenceContainerAt() {
    this.getClassAndName(["at", "operator[]"]) instanceof Array or
    this.getClassAndName(["at", "operator[]"]) instanceof Deque or
    this.getClassAndName(["at", "operator[]"]) instanceof Vector
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
