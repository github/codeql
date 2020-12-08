import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint

/**
 * The standard function `swap`.
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
 * The standard functions `std::string.swap` and `std::stringstream::swap`.
 */
private class StdStringSwap extends TaintFunction {
  StdStringSwap() {
    this.hasQualifiedName("std", "basic_string", "swap") or
    this.hasQualifiedName("std", "basic_stringstream", "swap")
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // str1.swap(str2)
    input.isQualifierObject() and
    output.isParameterDeref(0)
    or
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}

/**
 * The standard container `swap` functions.
 */
private class StdSequenceContainerSwap extends TaintFunction {
  StdSequenceContainerSwap() {
    this.hasQualifiedName("std", ["array", "vector", "deque", "list", "forward_list"], "swap")
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // container1.swap(container2)
    input.isQualifierObject() and
    output.isParameterDeref(0)
    or
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}

/**
 * The standard set `swap` functions.
 */
private class StdSetSwap extends TaintFunction {
  StdSetSwap() { this.hasQualifiedName("std", ["set", "unordered_set"], "swap") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // container1.swap(container2)
    input.isQualifierObject() and
    output.isParameterDeref(0)
    or
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}

/**
 * The standard pair `swap` function.
 */
private class StdPairSwap extends TaintFunction {
  StdPairSwap() { this.hasQualifiedName("std", "pair", "swap") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // container1.swap(container2)
    input.isQualifierObject() and
    output.isParameterDeref(0)
    or
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}

/**
 * The standard map `swap` function.
 */
private class StdMapSwap extends TaintFunction {
  StdMapSwap() { this.hasQualifiedName("std", ["map", "unordered_map"], "swap") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // container1.swap(container2)
    input.isQualifierObject() and
    output.isParameterDeref(0)
    or
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}
