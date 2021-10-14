import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.PointerWrapper

/**
 * The `std::shared_ptr`, `std::weak_ptr`, and `std::unique_ptr` template classes.
 */
private class SmartPtr extends Class, PointerWrapper {
  SmartPtr() { this.hasQualifiedName(["std", "bsl"], ["shared_ptr", "weak_ptr", "unique_ptr"]) }

  override MemberFunction getAnUnwrapperFunction() {
    result.(OverloadedPointerDereferenceFunction).getDeclaringType() = this
    or
    result.getClassAndName(["operator->", "get"]) = this
  }

  override predicate pointsToConst() { this.getTemplateArgument(0).(Type).isConst() }
}

/**
 * Any function that returns the address wrapped by a `PointerWrapper`, whether as a pointer or a
 * reference.
 *
 * Examples:
 * - `std::unique_ptr<T>::get()`
 * - `std::shared_ptr<T>::operator->()`
 * - `std::weak_ptr<T>::operator*()`
 */
private class PointerUnwrapperFunction extends MemberFunction, TaintFunction, DataFlowFunction,
  SideEffectFunction, AliasFunction {
  PointerUnwrapperFunction() {
    exists(PointerWrapper wrapper | wrapper.getAnUnwrapperFunction() = this)
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and output.isReturnValue()
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    // Only reads from `*this`.
    i = -1 and buffer = false
  }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasAddressFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and output.isReturnValue()
  }
}

/**
 * The `std::make_shared` and `std::make_unique` template functions.
 */
private class MakeUniqueOrShared extends TaintFunction {
  MakeUniqueOrShared() { this.hasQualifiedName(["bsl", "std"], ["make_shared", "make_unique"]) }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // Exclude the specializations of `std::make_shared` and `std::make_unique` that allocate arrays
    // since these just take a size argument, which we don't want to propagate taint through.
    not this.isArray() and
    (
      input.isParameter([0 .. this.getNumberOfParameters() - 1])
      or
      input.isParameterDeref([0 .. this.getNumberOfParameters() - 1])
    ) and
    output.isReturnValue()
  }

  /**
   * Holds if the function returns a `shared_ptr<T>` (or `unique_ptr<T>`) where `T` is an
   * array type (i.e., `U[]` for some type `U`).
   */
  predicate isArray() {
    this.getTemplateArgument(0).(Type).getUnderlyingType() instanceof ArrayType
  }
}

/**
 * A function that sets the value of a smart pointer.
 *
 * This could be a constructor, an assignment operator, or a named member function like `reset()`.
 */
private class SmartPtrSetterFunction extends MemberFunction, AliasFunction, SideEffectFunction {
  SmartPtrSetterFunction() {
    this.getDeclaringType() instanceof SmartPtr and
    not this.isStatic() and
    (
      this instanceof Constructor
      or
      this.hasName("operator=")
      or
      this.hasName("reset")
    )
  }

  override predicate hasOnlySpecificReadSideEffects() { none() }

  override predicate hasOnlySpecificWriteSideEffects() { none() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    // Always write to the destination smart pointer itself.
    i = -1 and buffer = false and mustWrite = true
    or
    // When taking ownership of a smart pointer via an rvalue reference, always overwrite the input
    // smart pointer.
    this.getPointerInput().isParameterDeref(i) and
    this.getParameter(i).getUnspecifiedType() instanceof RValueReferenceType and
    buffer = false and
    mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getPointerInput().isParameterDeref(i) and
    buffer = false
    or
    not this instanceof Constructor and
    i = -1 and
    buffer = false
  }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasAddressFlow(FunctionInput input, FunctionOutput output) {
    input = this.getPointerInput() and
    output.isQualifierObject()
    or
    // Assignment operator always returns a reference to `*this`.
    this.hasName("operator=") and
    input.isQualifierAddress() and
    output.isReturnValue()
  }

  private FunctionInput getPointerInput() {
    exists(Parameter param0 | param0 = this.getParameter(0) |
      (
        param0.getUnspecifiedType().(ReferenceType).getBaseType() instanceof SmartPtr and
        if this.getParameter(1).getUnspecifiedType() instanceof PointerType
        then
          // This is one of the constructors of `std::shared_ptr<T>` that creates a smart pointer that
          // wraps a raw pointer with ownership controlled by an unrelated smart pointer. We propagate
          // the raw pointer in the second parameter, rather than the smart pointer in the first
          // parameter.
          result.isParameter(1)
        else result.isParameterDeref(0)
        or
        // One of the functions that takes ownership of a raw pointer.
        param0.getUnspecifiedType() instanceof PointerType and
        result.isParameter(0)
      )
    )
  }
}
