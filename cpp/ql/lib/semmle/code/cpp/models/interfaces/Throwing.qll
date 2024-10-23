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
 * Represents a type of exception,
 * either Structure Exception Handling (SEH) or C++ exceptions.
 */
newtype TException =
  TSEHException() or
  TCxxException()

/**
 * Functions with information about how an exception is throwwn or if one is thrown at all.
 * If throwing details conflict for the same function, IR is assumed
 * to use the most restricted interpretation, meaning taking options
 * that stipulate no exception is raised, before the exception is always raised,
 * before conditional exceptions.
 *
 * Annotations must specify if the exception is from SEH (structured exception handling)
 * or ordinary c++ exceptions.
 */
abstract private class ExceptionAnnotation extends Function {
  /**
   * Returns the type of exception this annotation is for,
   * either a CPP exception or a STructured Exception Handling (SEH) exception.
   */
  abstract TException getExceptionType();

  /**
   * Holds if the exception type of this annotation is for a Structure Exception Handling (SEH) exception.
   */
  final predicate isSEH() { this.getExceptionType() = TSEHException() }

  /**
   * Holds if the exception type of this annotation is for a CPP exception.
   */
  final predicate isCxx() { this.getExceptionType() = TCxxException() }
}

/**
 * Functions that are known to not throw an exception.
 */
abstract class NonThrowingFunction extends ExceptionAnnotation { }

/**
 * Functions that are known to raise an exception.
 */
abstract class ThrowingFunction extends ExceptionAnnotation {
  ThrowingFunction() { this instanceof Function }

  /**
   * Holds if this function may raise an exception during evaluation.
   * If `conditional` is `false` the function may raise, and if `true` the function
   * will always raise an exception.
   * Do not specify `none()` if no exception is raised, instead use the
   * `NonThrowingFunction` class instead.
   */
  abstract predicate raisesException(boolean unconditional);

  /**
   * Holds if this function will always raise an exception if called
   */
  final predicate alwaysRaisesException() { this.raisesException(true) }

  /**
   * Holds if this function may raise an exception if called but
   * it is not guaranteed to do so. I.e., the function does not always raise an exception.
   */
  final predicate mayRaiseException() { this.raisesException(false) }
}
