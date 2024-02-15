import semmle.code.cpp.Function
import FunctionInputsAndOutputs
import semmle.code.cpp.models.Models

/**
 * A function that may (but not always) updates (part of) a `FunctionOutput`.
 */
abstract class PartialFlowFunction extends Function {
  /**
   * Holds if the write to `output` either is:
   * - Only partially updating the `output`
   * - Is not unconditional
   */
  predicate isPartialWrite(FunctionOutput output) { none() }
}
