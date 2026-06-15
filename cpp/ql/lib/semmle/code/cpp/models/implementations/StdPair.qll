/**
 * Provides models for the C++ `std::pair` class.
 */

import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * An instantiation of `std::pair<T1, T2>`.
 */
private class StdPair extends ClassTemplateInstantiation {
  StdPair() { this.hasQualifiedName(["std", "bsl"], "pair") }
}

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
private class StdPairConstructor extends Constructor, TaintFunction, AliasFunction,
  SideEffectFunction
{
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

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    // All the constructor parameters are references with the exception of this one:
    // ```
    // template<class... Args1, class... Args2>
    // pair(std::piecewise_construct_t, std::tuple<Args1...> first_args, std::tuple<Args2...> second_args);
    // ```
    // So we need to check that the parameters are actually references
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and
    buffer = false
  }
}

private class StdPairDestructor extends Destructor, AliasFunction, SideEffectFunction {
  StdPairDestructor() { this.getDeclaringType() instanceof StdPair }

  private Type getFirstType() { result = this.getDeclaringType().getTemplateArgument(0) }

  private Type getSecondType() { result = this.getDeclaringType().getTemplateArgument(0) }

  private Type getAType() { result = [this.getFirstType(), this.getSecondType()] }

  /**
   * Gets the destructor associated with the base type of this pair
   */
  private Destructor getADestructor() { result.getDeclaringType() = this.getAType() }

  override predicate hasOnlySpecificReadSideEffects() {
    this.getADestructor().(SideEffectFunction).hasOnlySpecificReadSideEffects()
    or
    // If there's no declared destructor for the base type then it won't have
    // any strange read side effects.
    not exists(this.getADestructor())
  }

  override predicate hasOnlySpecificWriteSideEffects() {
    this.getADestructor().(SideEffectFunction).hasOnlySpecificWriteSideEffects()
    or
    // If there's no declared destructor for the base type then it won't have
    // any strange write side effects.
    not exists(this.getADestructor())
  }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }

  override predicate parameterNeverEscapes(int index) {
    this.getADestructor().(AliasFunction).parameterNeverEscapes(index)
    or
    // If there's no declared destructor for the base type then it won't cause
    // anything to escape.
    not exists(this.getADestructor()) and
    index = -1
  }
}
