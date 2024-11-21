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
 *
 * DEPRECATED: use `AlwaysSehThrowingFunction` instead if a function unconditionally throws.
 * These are assumed the only case where functions throw/raise exceptions unconditionally.
 * For functions that may throw, this will be the default behavior in the IR.
 */
abstract deprecated class ThrowingFunction extends Function {
  ThrowingFunction() { any() }

  /**
   * Holds if this function may throw an exception during evaluation.
   * If `unconditional` is `true` the function always throws an exception.
   *
   * DPERECATED: for always throwing functions use `AlwaysSehThrowingFunction` instead.
   * For functions that may throw, this will be the default behavior in the IR.
   */
  abstract deprecated predicate mayThrowException(boolean unconditional);
}

/**
 * A function that is known to raise an exception unconditionally.
 * The only cases known where this happens is for SEH
 * (structured exception handling) exceptions.
 */
abstract class AlwaysSehThrowingFunction extends Function { }
