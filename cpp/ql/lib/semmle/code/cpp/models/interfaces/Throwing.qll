/**
 * Provides an abstract class for modeling whether a function may throw an
 * exception.
 * To use this QL library, create a QL class extending `ThrowingFunction` with
 * a characteristic predicate that selects the function or set of functions you
 * are modeling the exceptional flow of.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.Models
import semmle.code.cpp.models.interfaces.FunctionInputsAndOutputs

/**
 * A function that is known to raise an exception.
 */
abstract class ThrowingFunction extends Function {
  /**
   * Holds if this function may throw an exception during evaluation.
   * If `unconditional` is `true` the function always throws an exception.
   */
  abstract predicate mayThrowException(boolean unconditional);
}

/**
 * A function that unconditionally raises a structured exception handling (SEH) exception.
 */
abstract class AlwaysSehThrowingFunction extends Function { }
