/**
 * Provides models for C++ containers `std::map` and `std::unordered_map`.
 */

import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.implementations.Iterator

/**
 * The standard map `insert` function.
 */
class StdMapInsert extends TaintFunction {
  StdMapInsert() {
    this.hasQualifiedName("std", ["map", "unordered_map"], "insert")
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from last parameter to qualifier and return value
    // (where the return value is a pair, this should really flow just to the first part of it)
    input.isParameterDeref(getNumberOfParameters() - 1) and
    (
      output.isQualifierObject() or
      output.isReturnValue()
    )
  }
}

/**
 * The standard map `begin` and `end` functions and their
 * variants.
 */
class StdMapBeginEnd extends TaintFunction {
  StdMapBeginEnd() {
    this.hasQualifiedName("std", ["map", "unordered_map"], ["begin", "end", "cbegin", "cend"])
    or
    this.hasQualifiedName("std", "map", ["rbegin", "crbegin", "rend", "crend"])
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * The standard map `swap` functions.
 */
class StdMapSwap extends TaintFunction {
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
