/**
 * Provides models for C++ containers `std::set` and `std::unordered_set`.
 */

import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.implementations.Iterator

/**
 * Additional model for set constructors using iterator inputs.
 */
class StdSetConstructor extends Constructor, TaintFunction {
  StdSetConstructor() {
    this.hasQualifiedName("std", "set", "set") or
    this.hasQualifiedName("std", "unordered_set", "unordered_set")
  }

  /**
   * Gets the index of a parameter to this function that is an iterator.
   */
  int getAnIteratorParameterIndex() {
    getParameter(result).getUnspecifiedType() instanceof Iterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from any parameter of an iterator type to the qualifier
    input.isParameterDeref(getAnIteratorParameterIndex()) and
    (
      output.isReturnValue() // TODO: this is only needed for AST data flow, which treats constructors as returning the new object
      or
      output.isQualifierObject()
    )
  }
}

/**
 * The standard set `insert` and `insert_or_assign` functions.
 */
class StdSetInsert extends TaintFunction {
  StdSetInsert() { this.hasQualifiedName("std", ["set", "unordered_set"], "insert") }

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
 * The standard set `emplace` and `emplace_hint` functions.
 */
class StdSetEmplace extends TaintFunction {
  StdSetEmplace() {
    this.hasQualifiedName("std", ["set", "unordered_set"], ["emplace", "emplace_hint"])
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from any parameter to qualifier and return value
    // (here we assume taint flow from any constructor parameter to the constructed object)
    // (where the return value is a pair, this should really flow just to the first part of it)
    input.isParameterDeref([0 .. getNumberOfParameters() - 1]) and
    (
      output.isQualifierObject() or
      output.isReturnValue()
    )
    or
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
 * The standard set `merge` function.
 */
class StdSetMerge extends TaintFunction {
  StdSetMerge() { this.hasQualifiedName("std", ["set", "unordered_set"], "merge") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // container1.merge(container2)
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

/**
 * The standard set `lower_bound`, `upper_bound` and `equal_range` functions.
 */
class StdSetEqualRange extends TaintFunction {
  StdSetEqualRange() {
    this
        .hasQualifiedName("std", ["set", "unordered_set"],
          ["lower_bound", "upper_bound", "equal_range"])
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to return value
    input.isQualifierObject() and
    output.isReturnValue()
  }
}
