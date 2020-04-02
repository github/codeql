import semmle.code.cpp.models.interfaces.Taint

/**
 * The `std::basic_string` constructor(s).
 */
class StringConstructor extends TaintFunction {
  StringConstructor() { this.hasQualifiedName("std", "basic_string", "basic_string") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from any constructor argument to return value
    input.isInParameter(_) and
    output.isOutReturnValue()
  }
}

/**
 * The standard function `std::string.c_str`.
 */
class StringCStr extends TaintFunction {
  StringCStr() { this.hasQualifiedName("std", "basic_string", "c_str") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from string itself (qualifier) to return value
    input.isInQualifier() and
    output.isOutReturnValue()
  }
}
