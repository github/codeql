import semmle.code.cpp.models.interfaces.Taint

/**
 * The `std::shared_ptr` and `std::unique_ptr` template classes.
 */
class UniqueOrSharedPtr extends Class {
  UniqueOrSharedPtr() { this.hasQualifiedName("std", ["shared_ptr", "unique_ptr"]) }
}

/**
 * The `std::make_shared` and `std::make_unique` template functions.
 */
class MakeUniqueOrShared extends TaintFunction {
  MakeUniqueOrShared() { this.hasQualifiedName("std", ["make_shared", "make_unique"]) }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // Exclude the specializations of `std::make_shared` and `std::make_unique` that allocate arrays
    // since these just take a size argument, which we don't want to propagate taint through.
    not this.isArray() and
    (
      input.isParameter([0 .. getNumberOfParameters() - 1])
      or
      input.isParameterDeref([0 .. getNumberOfParameters() - 1])
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
 * A prefix `operator*` member function for a `shared_ptr` or `unique_ptr` type.
 */
class UniqueOrSharedDereferenceMemberOperator extends MemberFunction, TaintFunction {
  UniqueOrSharedDereferenceMemberOperator() {
    this.hasName("operator*") and
    this.getDeclaringType() instanceof UniqueOrSharedPtr
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }
}

/**
 * The `std::shared_ptr` or `std::unique_ptr` function `get`.
 */
class UniqueOrSharedGet extends TaintFunction {
  UniqueOrSharedGet() {
    this.hasName("get") and
    this.getDeclaringType() instanceof UniqueOrSharedPtr
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}
