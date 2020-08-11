import semmle.code.cpp.models.interfaces.Taint

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
