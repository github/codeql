/**
 * Provides models for C++ containers such as `std::vector` and `std::list`.
 */

import semmle.code.cpp.models.interfaces.Taint

/**
 * Model standard container constructors.
 */
class StdContainerConstructor extends Constructor, TaintFunction {
  StdContainerConstructor() { this.getDeclaringType().hasQualifiedName("std", "vector") }

  /**
   * Gets the index of a parameter to this function that is a reference to the
   * type of thing contained.
   */
  int getAnElementParameter() {
    getParameter(result).getType().getUnspecifiedType().(ReferenceType).getBaseType() =
      getDeclaringType().getTemplateArgument(0) // i.e. the `T` of this `std::vector<T>`
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from any parameter of type `T` to the returned object
    input.isParameterDeref(getAnElementParameter()) and
    output.isReturnValue() // TODO: this should be `isQualifierObject` by our current definitions, but that flow is not yet supported.
  }
}
