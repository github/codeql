/**
 * Provides an abstract class to override the implicit assumption that a
 * dataflow/taint-tracking model always fully override the parameters they are
 * are modeled as writing to. To use this QL library, create a QL class
 * extending `PartialFlowFunction` with a characteristic predicate that selects
 * the function or set of functions you are modeling and override the
 * `isPartialWrite` predicate.
 *
 * Note: Since both `DataFlowFunction` and `TaintFunction` extend this class
 * you don't need to explicitly add this as a base class if your QL class
 * already extends either `DataFlowFunction` or `TaintFunction`.
 */

import semmle.code.cpp.Function
import FunctionInputsAndOutputs
import semmle.code.cpp.models.Models

/**
 * A function that may update part of a `FunctionOutput`.
 *
 * For example, the destination argument of `strcat` only updates part of the
 * argument.
 */
abstract class PartialFlowFunction extends Function {
  /**
   * Holds if the write to output does not overwrite the entire value that was
   * there before, or does not do so reliably. For example the destination
   * argument of `strcat` is modified but not overwritten.
   */
  predicate isPartialWrite(FunctionOutput output) { none() }
}
