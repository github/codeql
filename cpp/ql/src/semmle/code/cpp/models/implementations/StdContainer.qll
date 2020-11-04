/**
 * Provides models for C++ containers `std::array`, `std::vector`, `std::deque`, `std::list` and `std::forward_list`.
 */

import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.implementations.Iterator

/**
 * Additional model for standard container constructors that reference the
 * value type of the container (that is, the `T` in `std::vector<T>`).  For
 * example the fill constructor:
 * ```
 * std::vector<std::string> v(100, potentially_tainted_string);
 * ```
 */
class StdSequenceContainerConstructor extends Constructor, TaintFunction {
  StdSequenceContainerConstructor() {
    this.getDeclaringType().hasQualifiedName("std", ["vector", "deque", "list", "forward_list"])
  }

  /**
   * Gets the index of a parameter to this function that is a reference to the
   * value type of the container.
   */
  int getAValueTypeParameterIndex() {
    getParameter(result).getUnspecifiedType().(ReferenceType).getBaseType() =
      getDeclaringType().getTemplateArgument(0).(Type).getUnspecifiedType() // i.e. the `T` of this `std::vector<T>`
  }

  /**
   * Gets the index of a parameter to this function that is an iterator.
   */
  int getAnIteratorParameterIndex() { getParameter(result).getType() instanceof Iterator }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from any parameter of the value type to the returned object
    (
      input.isParameterDeref(getAValueTypeParameterIndex()) or
      input.isParameter(getAnIteratorParameterIndex())
    ) and
    (
      output.isReturnValue() // TODO: this is only needed for AST data flow, which treats constructors as returning the new object
      or
      output.isQualifierObject()
    )
  }
}

/**
 * The standard container function `data`.
 */
class StdSequenceContainerData extends TaintFunction {
  StdSequenceContainerData() { this.hasQualifiedName("std", ["array", "vector"], "data") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from container itself (qualifier) to return value
    input.isQualifierObject() and
    output.isReturnValueDeref()
    or
    // reverse flow from returned reference to the qualifier (for writes to
    // `data`)
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }
}

/**
 * The standard container functions `push_back` and `push_front`.
 */
class StdSequenceContainerPush extends TaintFunction {
  StdSequenceContainerPush() {
    this.hasQualifiedName("std", "vector", "push_back") or
    this.hasQualifiedName("std", "deque", ["push_back", "push_front"]) or
    this.hasQualifiedName("std", "list", ["push_back", "push_front"]) or
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
class StdSequenceContainerFrontBack extends TaintFunction {
  StdSequenceContainerFrontBack() {
    this.hasQualifiedName("std", "array", ["front", "back"]) or
    this.hasQualifiedName("std", "vector", ["front", "back"]) or
    this.hasQualifiedName("std", "deque", ["front", "back"]) or
    this.hasQualifiedName("std", "list", ["front", "back"]) or
    this.hasQualifiedName("std", "forward_list", "front")
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from object to returned reference
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }
}

/**
 * The standard container functions `insert` and `insert_after`.
 */
class StdSequenceContainerInsert extends TaintFunction {
  StdSequenceContainerInsert() {
    this.hasQualifiedName("std", ["vector", "deque", "list"], "insert") or
    this.hasQualifiedName("std", ["forward_list"], "insert_after")
  }

  /**
   * Gets the index of a parameter to this function that is a reference to the
   * value type of the container.
   */
  int getAValueTypeParameterIndex() {
    getParameter(result).getUnspecifiedType().(ReferenceType).getBaseType() =
      getDeclaringType().getTemplateArgument(0).(Type).getUnspecifiedType() // i.e. the `T` of this `std::vector<T>`
  }

  /**
   * Gets the index of a parameter to this function that is an iterator.
   */
  int getAnIteratorParameterIndex() { getParameter(result).getType() instanceof Iterator }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from parameter to container itself (qualifier) and return value
    (
      input.isQualifierObject() or
      input.isParameterDeref(getAValueTypeParameterIndex()) or
      input.isParameter(getAnIteratorParameterIndex())
    ) and
    (
      output.isQualifierObject() or
      output.isReturnValueDeref()
    )
  }
}

/**
 * The standard container function `assign`.
 */
class StdSequenceContainerAssign extends TaintFunction {
  StdSequenceContainerAssign() {
    this.hasQualifiedName("std", ["vector", "deque", "list", "forward_list"], "assign")
  }

  /**
   * Gets the index of a parameter to this function that is a reference to the
   * value type of the container.
   */
  int getAValueTypeParameterIndex() {
    getParameter(result).getUnspecifiedType().(ReferenceType).getBaseType() =
      getDeclaringType().getTemplateArgument(0).(Type).getUnspecifiedType() // i.e. the `T` of this `std::vector<T>`
  }

  /**
   * Gets the index of a parameter to this function that is an iterator.
   */
  int getAnIteratorParameterIndex() { getParameter(result).getType() instanceof Iterator }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from parameter to container itself (qualifier)
    (
      input.isParameterDeref(getAValueTypeParameterIndex()) or
      input.isParameter(getAnIteratorParameterIndex())
    ) and
    output.isQualifierObject()
  }
}

/**
 * The standard container `swap` functions.
 */
class StdSequenceContainerSwap extends TaintFunction {
  StdSequenceContainerSwap() {
    this.hasQualifiedName("std", ["array", "vector", "deque", "list", "forward_list"], "swap")
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

/**
 * The standard container functions `at` and `operator[]`.
 */
class StdSequenceContainerAt extends TaintFunction {
  StdSequenceContainerAt() {
    this.hasQualifiedName("std", ["vector", "array", "deque"], ["at", "operator[]"])
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to referenced return value
    input.isQualifierObject() and
    output.isReturnValueDeref()
    or
    // reverse flow from returned reference to the qualifier
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }
}

/**
 * The standard vector `emplace` function.
 */
class StdVectorEmplace extends TaintFunction {
  StdVectorEmplace() { this.hasQualifiedName("std", "vector", "emplace") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from any parameter except the position iterator to qualifier and return value
    // (here we assume taint flow from any constructor parameter to the constructed object)
    input.isParameter([1 .. getNumberOfParameters() - 1]) and
    (
      output.isQualifierObject() or
      output.isReturnValue()
    )
  }
}

/**
 * The standard vector `emplace_back` function.
 */
class StdVectorEmplaceBack extends TaintFunction {
  StdVectorEmplaceBack() { this.hasQualifiedName("std", "vector", "emplace_back") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from any parameter to qualifier
    // (here we assume taint flow from any constructor parameter to the constructed object)
    input.isParameter([0 .. getNumberOfParameters() - 1]) and
    output.isQualifierObject()
  }
}
