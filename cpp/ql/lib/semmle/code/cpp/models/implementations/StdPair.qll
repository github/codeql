/**
 * Provides models for the C++ `std::pair` class.
 */

import semmle.code.cpp.models.interfaces.Taint

/**
 * An instantiation of `std::pair<T1, T2>`.
 */
private class StdPair extends ClassTemplateInstantiation {
  StdPair() { this.hasQualifiedName(["std", "bsl"], "pair") }
}

/**
 * DEPRECATED: This is now called `StdPair` and is a private part of the
 * library implementation.
 */
deprecated class StdPairClass = StdPair;

/**
 * Any of the single-parameter constructors of `std::pair` that takes a reference to an
 * instantiation of `std::pair`. These constructors allow conversion between pair types when the
 * underlying element types are convertible.
 */
class StdPairCopyishConstructor extends Constructor, TaintFunction {
  StdPairCopyishConstructor() {
    this.getDeclaringType() instanceof StdPair and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getUnspecifiedType().(ReferenceType).getBaseType() instanceof StdPair
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from the source object to the constructed object
    input.isParameterDeref(0) and
    (
      output.isReturnValue()
      or
      output.isQualifierObject()
    )
  }
}

/**
 * Additional model for `std::pair` constructors.
 */
private class StdPairConstructor extends Constructor, TaintFunction {
  StdPairConstructor() { this.getDeclaringType() instanceof StdPair }

  /**
   * Gets the index of a parameter to this function that is a reference to
   * either value type of the pair.
   */
  int getAValueTypeParameterIndex() {
    this.getParameter(result).getUnspecifiedType().(ReferenceType).getBaseType() =
      this.getDeclaringType().getTemplateArgument(_).(Type).getUnspecifiedType() // i.e. the `T1` or `T2` of this `std::pair<T1, T2>`
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from second parameter of a value type to the qualifier
    this.getAValueTypeParameterIndex() = 1 and
    input.isParameterDeref(1) and
    (
      output.isReturnValue() // TODO: this is only needed for AST data flow, which treats constructors as returning the new object
      or
      output.isQualifierObject()
    )
  }
}
