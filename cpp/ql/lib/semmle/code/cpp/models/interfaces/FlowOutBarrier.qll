/**
 * Provides an abstract class for blocking flow out of functions. To use this
 * QL library, create a QL class extending `FlowOutBarrierFunction` with a
 * characteristic predicate that selects the function or set of functions you
 * are modeling. Within that class, override the predicates provided by
 * `FlowOutBarrierFunction` to match the flow within that function.
 */

import semmle.code.cpp.Function
import FunctionInputsAndOutputs

/**
 * A library function for which flow should not continue after reaching one
 * of its inputs.
 *
 * For example, since `std::swap(a, b)` swaps the values pointed to by `a`
 * and `b` there should not be use-use flow out of `a` or `b`.
 */
abstract class FlowOutBarrierFunction extends Function {
  /**
   * Holds if use-use flow should not continue onwards after reaching
   * the argument, qualifier, or buffer represented by `input`.
   */
  pragma[nomagic]
  abstract predicate isFlowOutBarrier(FunctionInput input);
}
