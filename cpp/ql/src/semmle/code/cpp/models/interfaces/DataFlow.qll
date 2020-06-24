/**
 * Provides an abstract class for accurate dataflow modeling of library
 * functions when source code is not available.  To use this QL library,
 * create a QL class extending `DataFlowFunction` with a characteristic
 * predicate that selects the function or set of functions you are modeling.
 * Within that class, override the predicates provided by `DataFlowFunction`
 * to match the flow within that function.
 */

import semmle.code.cpp.Function
import FunctionInputsAndOutputs
import semmle.code.cpp.models.Models

/**
 * A library function for which a value is or may be copied from a parameter
 * or qualifier to an output buffer, return value, or qualifier.
 *
 * Note that this does not include partial copying of values or partial writes
 * to destinations; that is covered by `TaintModel.qll`.
 */
abstract class DataFlowFunction extends Function {
  /**
   * Holds if data can be copied from the argument, qualifier, or buffer
   * represented by `input` to the return value or buffer represented by
   * `output`
   */
  abstract predicate hasDataFlow(FunctionInput input, FunctionOutput output);
}
