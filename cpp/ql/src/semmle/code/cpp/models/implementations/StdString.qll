import semmle.code.cpp.models.interfaces.Taint

/**
 * The `std::basic_string` template class.
 */
class StdBasicString extends TemplateClass {
  StdBasicString() { this.hasQualifiedName("std", "basic_string") }
}

/**
 * The standard function `std::string.c_str`.
 */
class StdStringCStr extends TaintFunction {
  StdStringCStr() { this.hasQualifiedName("std", "basic_string", "c_str") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from string itself (qualifier) to return value
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * The `std::string` function `operator+`.
 */
class StdStringPlus extends TaintFunction {
  StdStringPlus() {
    this.hasQualifiedName("std", "operator+") and
    this.getParameter(0).getType().getUnspecifiedType().(ReferenceType).getBaseType() = any(StdBasicString s).getAnInstantiation()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from parameters to return value
    (
      input.isParameterDeref(0) or
      input.isParameterDeref(1)
    ) and
    output.isReturnValueDeref()
  }
}

/**
 * The `std::string` function `append`.
 */
class StdStringAppend extends TaintFunction {
  StdStringAppend() { this.hasQualifiedName("std", "basic_string", "append") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from parameter to string itself (qualifier) and return value
    input.isParameterDeref(0) and
    (
      output.isQualifierObject() or
      output.isReturnValueDeref()
    )
  }
}
