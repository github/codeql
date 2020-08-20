/**
 * Provides models for C++ containers `std::array`, `std::vector`, `std::deque`, `std::list` and `std::forward_list`.
 */

import semmle.code.cpp.models.interfaces.Taint

/**
 * Additional model for standard container constructors that reference the
 * value type of the container (that is, the `T` in `std::vector<T>`).  For
 * example the fill constructor:
 * ```
 * std::vector<std::string> v(100, potentially_tainted_string);
 * ```
 */
class StdContainerConstructor extends Constructor, TaintFunction {
  StdContainerConstructor() {
    this.getDeclaringType().hasQualifiedName("std", "vector") or
    this.getDeclaringType().hasQualifiedName("std", "deque") or
    this.getDeclaringType().hasQualifiedName("std", "list") or
    this.getDeclaringType().hasQualifiedName("std", "forward_list")
  }

  /**
   * Gets the index of a parameter to this function that is a reference to the
   * value type of the container.
   */
  int getAValueTypeParameter() {
    getParameter(result).getType().getUnspecifiedType().(ReferenceType).getBaseType() =
      getDeclaringType().getTemplateArgument(0) // i.e. the `T` of this `std::vector<T>`
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from any parameter of the value type to the returned object
    input.isParameterDeref(getAValueTypeParameter()) and
    output.isReturnValue() // TODO: this should be `isQualifierObject` by our current definitions, but that flow is not yet supported.
  }
}

/**
 * The standard container functions `push_back` and `push_front`.
 */
class StdContainerPush extends TaintFunction {
  StdContainerPush() {
    this.hasQualifiedName("std", "vector", "push_back") or
    this.hasQualifiedName("std", "deque", "push_back") or
    this.hasQualifiedName("std", "deque", "push_front") or
    this.hasQualifiedName("std", "list", "push_back") or
    this.hasQualifiedName("std", "list", "push_front") or
    this.hasQualifiedName("std", "forward_list", "push_front")
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from parameter to qualifier
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}

/**
 * The standard container functions `front` and `back`.
 */
class StdContainerFrontBack extends TaintFunction {
  StdContainerFrontBack() {
    this.hasQualifiedName("std", "array", "front") or
    this.hasQualifiedName("std", "array", "back") or
    this.hasQualifiedName("std", "vector", "front") or
    this.hasQualifiedName("std", "vector", "back") or
    this.hasQualifiedName("std", "deque", "front") or
    this.hasQualifiedName("std", "deque", "back") or
    this.hasQualifiedName("std", "list", "front") or
    this.hasQualifiedName("std", "list", "back") or
    this.hasQualifiedName("std", "forward_list", "front")
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from object to returned reference
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }
}

/**
 * The standard container `swap` functions.
 */
class StdContainerSwap extends TaintFunction {
  StdContainerSwap() {
    this.hasQualifiedName("std", "array", "swap") or
    this.hasQualifiedName("std", "vector", "swap") or
    this.hasQualifiedName("std", "deque", "swap") or
    this.hasQualifiedName("std", "list", "swap") or
    this.hasQualifiedName("std", "forward_list", "swap")
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // container1.swap(container2)
    input.isQualifierObject() and
    output.isParameterDeref(0)
    or
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}
