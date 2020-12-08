import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint

/**
 * The standard function `swap`. A use of `swap` looks like this:
 * ```
 * std::swap(obj1, obj2)
 * ```
 */
private class Swap extends DataFlowFunction {
  Swap() { this.hasQualifiedName("std", "swap") }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isParameterDeref(1)
    or
    input.isParameterDeref(1) and
    output.isParameterDeref(0)
  }
}

/**
 * A `swap` member function that is used as follows:
 * ```
 * obj1.swap(obj2)
 * ```
 */
private class MemberSwap extends TaintFunction {
  MemberSwap() {
    this.hasQualifiedName("std", "basic_string", "swap") or
    this.hasQualifiedName("std", "basic_stringstream", "swap") or
    this.hasQualifiedName("std", ["array", "vector", "deque", "list", "forward_list"], "swap") or
    this.hasQualifiedName("std", ["set", "unordered_set"], "swap") or
    this.hasQualifiedName("std", "pair", "swap") or
    this.hasQualifiedName("std", ["map", "unordered_map"], "swap") or
    this.hasQualifiedName("std", ["map", "unordered_map"], "swap")
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isParameterDeref(0)
    or
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}
