/**
 * Provides models for the C++ `std::pair` class.
 */

import semmle.code.cpp.models.interfaces.Taint

/**
 * Additional model for `std::pair` constructors.
 */
class StdPairConstructor extends Constructor, TaintFunction {
  StdPairConstructor() { this.hasQualifiedName("std", "pair", "pair") }

  /**
   * Gets the index of a parameter to this function that is a reference to
   * either value type of the pair.
   */
  int getAValueTypeParameterIndex() {
    getParameter(result).getUnspecifiedType().(ReferenceType).getBaseType() =
      getDeclaringType().getTemplateArgument(_).(Type).getUnspecifiedType() // i.e. the `T1` or `T2` of this `std::pair<T1, T2>`
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from second parameter of a value type to the qualifier
    getAValueTypeParameterIndex() = 1 and
    input.isParameterDeref(1) and
    (
      output.isReturnValue() // TODO: this is only needed for AST data flow, which treats constructors as returning the new object
      or
      output.isQualifierObject()
    )
  }
}

/**
 * The standard pair `swap` function.
 */
class StdPairSwap extends TaintFunction {
  StdPairSwap() { this.hasQualifiedName("std", "pair", "swap") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // container1.swap(container2)
    input.isQualifierObject() and
    output.isParameterDeref(0)
    or
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}
