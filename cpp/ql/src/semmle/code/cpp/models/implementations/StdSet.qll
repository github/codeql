/**
 * Provides models for C++ containers `std::set` and `std::unordered_set`.
 */

import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.implementations.Iterator

/**
 * The standard set `insert` and `insert_or_assign` functions.
 */
class StdSetInsert extends TaintFunction {
  StdSetInsert() {
    this.hasQualifiedName("std", ["set", "unordered_set"], "insert")
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
 * The standard set `begin` and `end` functions and their
 * variants.
 */
class StdSetBeginEnd extends TaintFunction {
  StdSetBeginEnd() {
    this.hasQualifiedName("std", ["set", "unordered_set"], ["begin", "end", "cbegin", "cend"])
    or
    this.hasQualifiedName("std", "set", ["rbegin", "crbegin", "rend", "crend"])
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * The standard set `swap` functions.
 */
class StdSetSwap extends TaintFunction {
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
 * The standard set `find` function.
 */
class StdSetFind extends TaintFunction {
  StdSetFind() { this.hasQualifiedName("std", ["set", "unordered_set"], "find") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * The standard set `erase` function.
 */
class StdSetErase extends TaintFunction {
  StdSetErase() { this.hasQualifiedName("std", ["set", "unordered_set"], "erase") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to iterator return value
    getType().getUnderlyingType() instanceof Iterator and
    input.isQualifierObject() and
    output.isReturnValue()
  }
}
