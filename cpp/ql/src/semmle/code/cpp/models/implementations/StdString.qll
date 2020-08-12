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
    this.getUnspecifiedType() = any(StdBasicString s).getAnInstantiation()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from parameters to return value
    (
      input.isParameterDeref(0) or
      input.isParameterDeref(1)
    ) and
    output.isReturnValue()
  }
}

/**
 * The `std::string` functions `operator+=` and `append`.
 */
class StdStringAppend extends TaintFunction {
  StdStringAppend() {
    this.hasQualifiedName("std", "basic_string", "operator+=") or
    this.hasQualifiedName("std", "basic_string", "append")
  }

  /**
   * Gets the index of a parameter to this function that is a string.
   */
  int getAStringParameter() {
    getParameter(result).getType() instanceof PointerType or
    getParameter(result).getType() instanceof ReferenceType
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from parameter to string itself (qualifier) and return value
    input.isParameterDeref(getAStringParameter()) and
    (
      output.isQualifierObject() or
      output.isReturnValueDeref()
    )
  }
}
