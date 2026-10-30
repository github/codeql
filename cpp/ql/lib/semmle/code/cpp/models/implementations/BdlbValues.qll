/**
 * Models contained values, copying, assignment, and scalar emplacement in BDE wrappers.
 * `NullableValue` inherits `operator*` and `operator->` from optional; those
 * declarations belong to the separate optional models, not to this module.
 */

private import cpp
private import semmle.code.cpp.dataflow.internal.FlowSummaryImpl::Public
private import semmle.code.cpp.models.implementations.internal.ValueWrapper

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
    noUserDefinedConversion(inputType, storedType)
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, Provenance provenance, boolean isExact,
    string model
  ) {
    (
      exists(string stars | stars = getContentStars() |
        input = "Argument[*" + stars + "0]" and
        (
          output = "Argument[-1].Element[" + stars + "]"
          or
          nullable = true and output = "ReturnValue[*" + stars + "]"
        ) and
        preservesValue = preservesConvertedValue(inputType, storedType, stars)
      )
      or
      nullable = true and
      exists(string stars | stars = getContentStars() |
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

/**
 * Models single-argument scalar emplacement only. Class-typed and multi-argument
 * construction is left to body analysis; see `multiArgumentNullable` and
 * `ignoredArgumentNullable` in `emplacement.cpp`. Body analysis can track the
 * direct result, but does not automatically populate abstract wrapper contents.
 * Broader emplacement and `bdlat_NullableValueFunctions::accessValue` and
 * `manipulateValue` belong with the separate Bloomberg pack models.
 */
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
    (isNumeric(inputType) or inputType instanceof PointerType) and
    storedType =
      this.getType().getUnspecifiedType().(ReferenceType).getBaseType().getUnspecifiedType() and
    (isNumeric(storedType) or storedType instanceof PointerType) and
    noUserDefinedConversion(inputType, storedType)
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, Provenance provenance, boolean isExact,
    string model
  ) {
    (
      exists(string stars | stars = getContentStars() |
        input = "Argument[*" + stars + "0]" and
        output = ["Argument[-1].Element[" + stars + "]", "ReturnValue[*" + stars + "]"] and
        preservesValue = preservesConvertedValue(inputType, storedType, stars)
      )
      or
      exists(string stars | stars = getContentStars() |
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

/**
 * Models writes through references and pointers returned into a wrapper.
 * Input `@` is expanded by ExternalFlow, but validating high return indirections
 * in a database without those return types produces spurious diagnostics. Keep
 * the depth expansion here, where summaries are selected by actual functions.
 * Engagement is not tracked: reset and disengagement do not clear contents.
 */
private class WrapperAccessor extends SummarizedCallable {
  WrapperAccessor() {
    this.getDeclaringType().hasQualifiedName("BloombergLP::bdlb", "NullableValue") and
    (
      this.hasName(["value", "valueOrNull", "addressOr"])
      or
      this.hasName("valueOr") and this.getParameter(0).getUnspecifiedType() instanceof PointerType
    )
    or
    this.getDeclaringType().hasQualifiedName("BloombergLP::bdlb", "VariantImp") and
    this.hasName("the")
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, Provenance provenance, boolean isExact,
    string model
  ) {
    exists(string stars | stars = getContentStars() |
      input = "ReturnValue[*" + stars + "]" and
      output = "Argument[-1].Element[" + stars + "]"
      or
      this.hasName(["valueOrNull", "addressOr", "valueOr"]) and
      input = "Argument[-1].Element[" + stars + "]" and
      output = "ReturnValue[*" + stars + "]"
      or
      this.hasName(["addressOr", "valueOr"]) and
      input = "Argument[*" + stars + "0]" and
      output = "ReturnValue[*" + stars + "]"
    ) and
    preservesValue = true and
    provenance = "manual" and
    isExact = true and
    model = ""
    or
    this.hasName(["addressOr", "valueOr"]) and
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = true and
    provenance = "manual" and
    isExact = true and
    model = ""
  }
}

/** Models the by-value overload of `valueOr`, including pointer payload contents. */
private class NullableValueOr extends SummarizedCallable {
  NullableValueOr() {
    this.getDeclaringType().hasQualifiedName("BloombergLP::bdlb", "NullableValue") and
    this.hasName("valueOr") and
    this.getParameter(0).getUnspecifiedType() instanceof ReferenceType
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, Provenance provenance, boolean isExact,
    string model
  ) {
    exists(string stars | stars = getContentStars() |
      input = ["Argument[-1].Element[" + stars + "]", "Argument[*" + stars + "0]"] and
      (if stars = "" then output = "ReturnValue" else output = "ReturnValue[" + stars + "]")
    ) and
    preservesValue = true and
    provenance = "manual" and
    isExact = true and
    model = ""
  }
}

/** Holds if `c` is a BDE value wrapper with its own copy and move declarations. */
private predicate isValueWrapper(Class c) {
  c.hasQualifiedName("BloombergLP::bdlb", ["NullableValue", "VariantImp", "Variant"])
  or
  c.hasQualifiedName("BloombergLP::bdlb", "Variant" + [2 .. 19].toString())
}

/**
 * Models same-specialization copies and C++11 moves, including allocator-extended
 * constructors. C++03 `bslmf::MovableRef` class-based move emulation is out of scope.
 * Scalar/value converting constructors and assignments are not wrapper copies.
 */
private class WrapperCopy extends SummarizedCallable {
  WrapperCopy() {
    isValueWrapper(this.getDeclaringType()) and
    this.getParameter(0).getUnspecifiedType().(ReferenceType).getBaseType().getUnspecifiedType() =
      this.getDeclaringType() and
    (
      this instanceof Constructor and
      (
        this.getNumberOfParameters() = 1
        or
        this.getNumberOfParameters() = 2 and
        (
          this.getParameter(1)
              .getUnspecifiedType()
              .(PointerType)
              .getBaseType()
              .getUnspecifiedType()
              .(Class)
              .hasQualifiedName("BloombergLP::bslma", "Allocator")
          or
          this.getParameter(1)
              .getUnspecifiedType()
              .(ReferenceType)
              .getBaseType()
              .getUnspecifiedType()
              .(Class)
              .hasQualifiedName("bsl", "allocator")
        )
      )
      or
      this.hasName("operator=") and this.getNumberOfParameters() = 1
    )
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, Provenance provenance, boolean isExact,
    string model
  ) {
    (
      exists(string stars | stars = getContentStars() |
        input = "Argument[*0].Element[" + stars + "]" and
        (
          output = "Argument[-1].Element[" + stars + "]"
          or
          this.hasName("operator=") and output = "ReturnValue[*].Element[" + stars + "]"
        )
      )
      or
      this.hasName("operator=") and input = "Argument[-1]" and output = "ReturnValue[*]"
    ) and
    preservesValue = true and
    provenance = "manual" and
    isExact = true and
    model = ""
  }
}
