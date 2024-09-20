/**
 * Provides models for C++ containers `std::set` and `std::unordered_set`.
 */

import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Iterator

/**
 * An instantiation of `std::set` or `std::unordered_set`.
 */
private class StdSet extends ClassTemplateInstantiation {
  StdSet() { this.hasQualifiedName(["std", "bsl"], ["set", "unordered_set"]) }
}

/**
 * Additional model for set constructors using iterator inputs.
 */
private class StdSetConstructor extends Constructor, TaintFunction {
  StdSetConstructor() { this.getDeclaringType() instanceof StdSet }

  /**
   * Gets the index of a parameter to this function that is an iterator.
   */
  int getAnIteratorParameterIndex() {
    this.getParameter(result).getUnspecifiedType() instanceof Iterator
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from any parameter of an iterator type to the qualifier
    (
      // AST dataflow doesn't have indirection for iterators.
      // Once we deprecate AST dataflow we can delete this first disjunct.
      input.isParameter(this.getAnIteratorParameterIndex()) or
      input.isParameterDeref(this.getAnIteratorParameterIndex())
    ) and
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
private class StdSetInsert extends TaintFunction {
  StdSetInsert() { this.getClassAndName("insert") instanceof StdSet }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from last parameter to qualifier and return value
    // (where the return value is a pair, this should really flow just to the first part of it)
    (
      // AST dataflow doesn't have indirection for iterators.
      // Once we deprecate AST dataflow we can delete this first disjunct.
      input.isParameter(this.getNumberOfParameters() - 1) or
      input.isParameterDeref(this.getNumberOfParameters() - 1)
    ) and
    (
      output.isQualifierObject() or
      output.isReturnValue()
    )
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }
}

/**
 * The standard set `emplace` and `emplace_hint` functions.
 */
private class StdSetEmplace extends TaintFunction {
  StdSetEmplace() { this.getClassAndName(["emplace", "emplace_hint"]) instanceof StdSet }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from any parameter to qualifier and return value
    // (here we assume taint flow from any constructor parameter to the constructed object)
    // (where the return value is a pair, this should really flow just to the first part of it)
    input.isParameterDeref([0 .. this.getNumberOfParameters() - 1]) and
    (
      output.isQualifierObject() or
      output.isReturnValue()
    )
    or
    input.isQualifierObject() and
    output.isReturnValue()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }
}

/**
 * The standard set `merge` function.
 */
private class StdSetMerge extends TaintFunction {
  StdSetMerge() { this.getClassAndName("merge") instanceof StdSet }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // container1.merge(container2)
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }
}

/**
 * The standard set `find` function.
 */
private class StdSetFind extends TaintFunction {
  StdSetFind() { this.getClassAndName("find") instanceof StdSet }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * The standard set `erase` function.
 */
private class StdSetErase extends TaintFunction {
  StdSetErase() { this.getClassAndName("erase") instanceof StdSet }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to iterator return value
    this.getType().getUnderlyingType() instanceof Iterator and
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * The standard set `lower_bound`, `upper_bound` and `equal_range` functions.
 */
private class StdSetEqualRange extends TaintFunction {
  StdSetEqualRange() {
    this.getClassAndName(["lower_bound", "upper_bound", "equal_range"]) instanceof StdSet
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to return value
    input.isQualifierObject() and
    output.isReturnValue()
  }
}
