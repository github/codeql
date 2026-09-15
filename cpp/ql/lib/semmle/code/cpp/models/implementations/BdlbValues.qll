/** Models type-aware assignment and scalar emplacement in BDE value wrappers. */

private import cpp
private import semmle.code.cpp.dataflow.internal.FlowSummaryImpl::Public

/** Assignments preserve aggregate fields when the input has the stored type. */
private class WrapperAssignment extends SummarizedCallable {
  Type inputType;
  Type storedType;
  boolean nullable;

  WrapperAssignment() {
    this.getNumberOfParameters() = 1 and
    inputType =
      this.getParameter(0).getUnspecifiedType().(ReferenceType).getBaseType().getUnspecifiedType() and
    (
      this.hasName("makeValue") and
      this.getDeclaringType().hasQualifiedName("BloombergLP::bdlb", "NullableValue") and
      nullable = true and
      storedType =
        this.getType().getUnspecifiedType().(ReferenceType).getBaseType().getUnspecifiedType()
      or
      this.hasName("assign") and
      this.getDeclaringType().hasQualifiedName("BloombergLP::bdlb", "VariantImp") and
      nullable = false and
      storedType = inputType
    ) and
    (
      inputType = storedType
      or
      inputType instanceof ArithmeticType and storedType instanceof ArithmeticType
    )
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, Provenance provenance, boolean isExact,
    string model
  ) {
    (
      exists(string stars | stars = ["", "*", "**", "***", "****"] |
        input = "Argument[*" + stars + "0]" and
        (
          output = "Argument[-1].Element[" + stars + "]"
          or
          nullable = true and output = "ReturnValue[*" + stars + "]"
        )
      ) and
      (if inputType = storedType then preservesValue = true else preservesValue = false)
      or
      nullable = true and
      exists(string stars | stars = ["", "*"] |
        input = "ReturnValue[*" + stars + "]" and
        output = "Argument[-1].Element[" + stars + "]"
      ) and
      preservesValue = true
      or
      nullable = false and
      input = "Argument[-1]" and
      output = "ReturnValue[*]" and
      preservesValue = true
    ) and
    provenance = "manual" and
    isExact = true and
    model = ""
  }
}

/** User-defined constructors are deliberately left to body analysis. */
private class ScalarEmplacement extends SummarizedCallable {
  Type inputType;
  Type storedType;

  ScalarEmplacement() {
    (
      this.hasName("makeValueInplace") and
      this.getDeclaringType().hasQualifiedName("BloombergLP::bdlb", "NullableValue")
      or
      this.hasName("createInPlace") and
      this.getDeclaringType().hasQualifiedName("BloombergLP::bdlb", "VariantImp")
    ) and
    this.getNumberOfParameters() = 1 and
    // Class inputs may invoke user-defined conversions even when the stored type is scalar.
    inputType =
      this.getParameter(0).getUnspecifiedType().(ReferenceType).getBaseType().getUnspecifiedType() and
    (inputType instanceof ArithmeticType or inputType instanceof PointerType) and
    storedType =
      this.getType().getUnspecifiedType().(ReferenceType).getBaseType().getUnspecifiedType() and
    (storedType instanceof ArithmeticType or storedType instanceof PointerType) and
    // Differing pointer types may require a base-subobject adjustment. Keep the conversion body.
    (
      inputType = storedType
      or
      inputType instanceof ArithmeticType and storedType instanceof ArithmeticType
    )
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, Provenance provenance, boolean isExact,
    string model
  ) {
    (
      exists(string stars | stars = ["", "*", "**", "***", "****"] |
        input = "Argument[*" + stars + "0]" and
        output = ["Argument[-1].Element[" + stars + "]", "ReturnValue[*" + stars + "]"]
      ) and
      (if inputType = storedType then preservesValue = true else preservesValue = false)
      or
      exists(string stars | stars = ["", "*"] |
        input = "ReturnValue[*" + stars + "]" and
        output = "Argument[-1].Element[" + stars + "]"
      ) and
      preservesValue = true
    ) and
    provenance = "manual" and
    isExact = true and
    model = ""
  }
}
