import semmle.code.cpp.models.interfaces.Taint

/**
 * The `std::basic_string` constructor(s).
 */
class StdStringConstructor extends TaintFunction {
  pragma[noinline]
  StdStringConstructor() { this.hasQualifiedName("std", "basic_string", "basic_string") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from any constructor argument to return value
    input.isParameter(_) and
    output.isReturnValue()
  }
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
