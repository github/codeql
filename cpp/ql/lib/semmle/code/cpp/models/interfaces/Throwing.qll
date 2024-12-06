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
 * DEPRECATED: This was originally used to differentiate Seh and C++ exception use. 
 * `AlwaysSehThrowingFunction` should be used instead for Seh exceptions that are 
 * known to always throw and 
 * `NonCppThrowingFunction` in `semmle.code.cpp.models.interfaces.NonThrowing`
 * should be used for C++ exceptions that are known to never throw. 
 */
abstract deprecated class ThrowingFunction extends Function {
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
