/**
 * Provides an abstract class for accurate alias modeling of library
 * functions when source code is not available.  To use this QL library,
 * create a QL class extending `AliasFunction` with a characteristic
 * predicate that selects the function or set of functions you are modeling.
 * Within that class, override the predicates provided by `AliasFunction`
 * to match the flow within that function.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.Models

/**
 * Models the aliasing behavior of a library function.
 */
abstract class AliasFunction extends Function {
  /**
   * Holds if the address passed to the parameter at the specified index is never retained after
   * the function returns.
   *
   * Example:
   * ```
   * int* g;
   * int* func(int* p, int* q, int* r, int* s, int n) {
   *   *s = 1;  // `s` does not escape.
   *   g = p;  // Stored in global. `p` escapes.
   *   if (rand()) {
   *     return q;  // `q` escapes via the return value.
   *   }
   *   else {
   *     return r + n;  // `r` escapes via the return value, even though an offset has been added.
   *   }
   * }
   * ```
   *
   * For the above function, the following terms hold:
   * - `parameterEscapesOnlyViaReturn(1)`
   * - `parameterEscapesOnlyViaReturn(2)`
   * - `parameterNeverEscapes(3)`
   */
  abstract predicate parameterNeverEscapes(int index);

  /**
   * Holds if the address passed to the parameter at the specified index escapes via the return
   * value of the function, but does not otherwise escape. See the comment for
   * `parameterNeverEscapes` for an example.
   */
  abstract predicate parameterEscapesOnlyViaReturn(int index);

  /**
   * Holds if the function always returns the value of the parameter at the specified index.
   */
  predicate parameterIsAlwaysReturned(int index) { none() }

  /**
   * Holds if the address passed in via `input` is always propagated to `output`.
   */
  predicate hasAddressFlow(FunctionInput input, FunctionOutput output) {
    exists(int index |
      // By default, just use the old `parameterIsAlwaysReturned` predicate to detect flow from the
      // parameter to the return value.
      input.isParameter(index) and output.isReturnValue() and this.parameterIsAlwaysReturned(index)
    )
  }
}
