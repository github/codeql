/**
 * Provides a class for modeling `printf`-style formatting functions. To use
 * this QL library, create a QL class extending `DataFlowFunction` with a
 * characteristic predicate that selects the function or set of functions you
 * are modeling. Within that class, override the predicates provided by
 * `FormattingFunction` to match the flow within that function.
 */

import semmle.code.cpp.Function
/**
 * A standard library function that uses a `printf`-like formatting string.
 */
abstract class FormattingFunction extends Function {
  /** Gets the position at which the format parameter occurs. */
  abstract int getFormatParameterIndex();

  /**
   * Holds if the default meaning of `%s` is a `wchar_t *`, rather than
   * a `char *` (either way, `%S` will have the opposite meaning).
   */
  predicate isWideCharDefault() { none() }

  /**
   * Gets the position at which the output parameter, if any, occurs.
   */
  int getOutputParameterIndex() { none() }

  /**
   * Gets the position of the first format argument, corresponding with
   * the first format specifier in the format string.
   */
  int getFirstFormatArgumentIndex() { result = getNumberOfParameters() }

  /**
   * Gets the position of the buffer size argument, if any.
   */
  int getSizeParameterIndex() { none() }
}