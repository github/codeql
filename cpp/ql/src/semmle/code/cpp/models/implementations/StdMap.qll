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
