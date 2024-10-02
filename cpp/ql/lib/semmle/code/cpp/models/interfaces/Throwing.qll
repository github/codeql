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

newtype TException =
  TSEHException() or
  TCxxException()

 /**
 * A class that models the exceptional behavior of a function.
 * This class models both Structed Exeception Handling (SEH) and C++ exceptions.
 * This class also models if a function is definitively known to never throw an exception
 * by concretizing the `raisesException` predicate to `none()`.
 * This class is designed to explicitly model exception behavior when known.
 * 
 * If throwing details conflict for the same function, IR is assumed
 * to use the most restricted interpretation, meaning taking options
 * that stipulate no exception is raised, before the exception is always raised,
 * before conditional exceptions.
 */
abstract class ExceptionAnnotation extends Function {
  // TException exceptionType;
  /**
   * Holds if this function may raise an exception during evaluation.
   * If `conditional` is `false` the function may raise, and if `true` the function
   * will always raise an exception.
   * To specify the function never raises an exception, concretize as `none()`.
   */
  abstract predicate raisesException(boolean unconditional);

  abstract TException getExceptionType();

  final predicate isSEH() { this.getExceptionType() = TSEHException() }

  final predicate isCxx() { this.getExceptionType() = TCxxException() }

  final predicate neverRaisesException() { not this.raisesException(_)}

  final predicate alwaysRaisesException() { this.raisesException(true) }

  final predicate mayRaiseException() { this.raisesException(false) }
}
