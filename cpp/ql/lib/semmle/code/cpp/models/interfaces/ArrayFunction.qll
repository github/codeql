/**
 * Provides an abstract class for accurate modeling of input and output buffers
 * in library functions when source code is not available.  To use this QL
 * library, create a QL class extending `ArrayFunction` with a characteristic
 * predicate that selects the function or set of functions you are trying to
 * model. Within that class, override the predicates provided by `ArrayFunction`
 * to match the flow within that function.  Finally, add a private import
 * statement to `Models.qll`
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.Models

/**
 * A library function with input and/or output buffer parameters
 */
abstract class ArrayFunction extends Function {
  /**
   * Holds if parameter `bufParam` is a null-terminated buffer and the
   * null-terminator will not be written past.
   */
  predicate hasArrayWithNullTerminator(int bufParam) { none() }

  /**
   * Holds if parameter `bufParam` should always point to a buffer with exactly
   * `elemCount` elements.
   */
  predicate hasArrayWithFixedSize(int bufParam, int elemCount) { none() }

  /**
   * Holds if parameter `bufParam` should always point to a buffer with the
   * number of elements indicated by `countParam`.
   */
  predicate hasArrayWithVariableSize(int bufParam, int countParam) { none() }

  /**
   * Holds if parameter `bufParam` points to a buffer with no fixed size and no
   * size parameter, which is not null-terminated or which is null-terminated
   * but for which the null value may be written past.  For example, the first
   * parameters of `sprintf` and `strcat`.
   */
  predicate hasArrayWithUnknownSize(int bufParam) { none() }

  /**
   * Holds if parameter `bufParam` is used as an input buffer.
   *
   * Note that this is not mutually exclusive with isOutBuffer.
   */
  predicate hasArrayInput(int bufParam) { none() }

  /**
   * Holds if parameter `bufParam` is used as an output buffer.
   *
   * Note that this is not mutually exclusive with isInBuffer.
   */
  predicate hasArrayOutput(int bufParam) { none() }
}
