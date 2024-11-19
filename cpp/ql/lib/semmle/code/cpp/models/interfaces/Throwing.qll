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
 * either Structured Exception Handling (SEH) or C++ exceptions.
 */
newtype TException =
  /** Structured Exception Handling (SEH) exception */
  TSehException() or
  /** C++ exception */
  TCxxException()

/**
 * Functions with information about how an exception is thrown or if one is thrown at all.
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
   * Holds if the exception type of this annotation is for a Structured Exception Handling (SEH) exception.
   */
  final predicate isSeh() { this.getExceptionType() = TSehException() }

  /**
   * Holds if the exception type of this annotation is for a CPP exception.
   */
  final predicate isCxx() { this.getExceptionType() = TCxxException() }
}

/**
 * A Function that is known to not throw an exception.
 */
abstract class NonThrowingFunction extends ExceptionAnnotation { }

/**
 * A function this is known to raise an exception.
 */
abstract class ThrowingFunction extends ExceptionAnnotation {
  ThrowingFunction() { any() }

  /**
   * Holds if this function may raise an exception during evaluation.
   * If `unconditional` is `false` the function may raise, and if `true` the function
   * will always raise an exception.
   * Do not specify `none()` if no exception is raised, instead use the
   * `NonThrowingFunction` class instead.
   */
  abstract predicate mayThrowException(boolean unconditional);

  /**
   * Holds if this function will always raise an exception if called
   */
  final predicate alwaysRaisesException() { this.mayThrowException(true) }
}
