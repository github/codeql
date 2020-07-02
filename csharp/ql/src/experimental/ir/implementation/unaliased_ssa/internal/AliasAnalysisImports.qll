private import csharp
import experimental.ir.implementation.IRConfiguration
import experimental.ir.internal.IntegerConstant as Ints

module AliasModels {
  /**
   * Models the aliasing behavior of a library function.
   */
  abstract class AliasFunction extends Callable {
    /**
     * Holds if the address passed to the parameter at the specified index is never retained after
     * the function returns.
     *
     * Example:
     * ```csharp
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
    abstract predicate parameterIsAlwaysReturned(int index);
  }
}
