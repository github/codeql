/** Models the contained value of standard and BDE optional objects. */

private import cpp
private import semmle.code.cpp.dataflow.internal.FlowSummaryImpl::Public

private predicate isOptional(Class c) {
  c.hasQualifiedName(["std", "bsl"], "optional") or
  c.hasQualifiedName("BloombergLP::bslstl", "Optional_Base")
}

/** Restrict value operations to types that need no user-defined conversion. */
private class OptionalValueOperation extends SummarizedCallable {
  Type sourceType;
  Type targetType;
  boolean copy;

  OptionalValueOperation() {
    isOptional(this.getDeclaringType()) and
    targetType = this.getDeclaringType().getTemplateArgument(0).(Type).getUnspecifiedType() and
    exists(Type argType |
      argType =
        this.getParameter(0).getUnspecifiedType().(ReferenceType).getBaseType().getUnspecifiedType() and
      (
        (this instanceof Constructor or this.hasName("operator=")) and
        // BDE constrains constructors with trailing defaulted tag parameters.
        forall(Parameter p | p = this.getAParameter() and p.getIndex() > 0 |
          p.getUnspecifiedType()
              .(Class)
              .hasQualifiedName("BloombergLP::bslstl", "Optional_OptNoSuchType")
        ) and
        (
          isOptional(argType.(Class)) and
          copy = true and
          sourceType = argType.(Class).getTemplateArgument(0).(Type).getUnspecifiedType()
          or
          copy = false and
          sourceType = argType and
          (sourceType = targetType or sourceType instanceof ArithmeticType)
        )
        or
        this.hasName("emplace") and
        this.getNumberOfParameters() = 1 and
        (targetType instanceof ArithmeticType or targetType instanceof PointerType) and
        copy = false and
        sourceType = argType
      )
    ) and
    (
      sourceType = targetType
      or
      sourceType instanceof ArithmeticType and targetType instanceof ArithmeticType
    )
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, Provenance provenance, boolean isExact,
    string model
  ) {
    (
      exists(string stars | stars = ["", "*", "**", "***", "****"] |
        (
          if copy = true
          then input = "Argument[*0].Element[" + stars + "]"
          else input = "Argument[*" + stars + "0]"
        ) and
        (
          output = "Argument[-1].Element[" + stars + "]"
          or
          this.hasName("emplace") and output = "ReturnValue[*" + stars + "]"
        )
      ) and
      (if sourceType = targetType then preservesValue = true else preservesValue = false)
      or
      this.hasName("operator=") and
      input = "Argument[-1]" and
      output = "ReturnValue[*]" and
      preservesValue = true
    ) and
    provenance = "manual" and
    isExact = true and
    model = ""
  }
}
