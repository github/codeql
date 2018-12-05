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

module AliasModel {
  private newtype TParameterEscape =
    TDoesNotEscape() or
    TEscapesOnlyViaReturn() or
    TEscapes()

  class ParameterEscape extends TParameterEscape {
    string toString() {
      result = "Unknown"
    }
  }

  class DoesNotEscape extends ParameterEscape, TDoesNotEscape {
    override string toString() {
      result = "DoesNotEscape"
    }
  }

  class EscapesOnlyViaReturn extends ParameterEscape, TEscapesOnlyViaReturn {
    override string toString() {
      result = "EscapesOnlyViaReturn"
    }
  }

  class Escapes extends ParameterEscape, TEscapes {
    override string toString() {
      result = "Escapes"
    }
  }

  /**
   * Models the aliasing behavior of a library function.
   */
  abstract class AliasFunction extends Function {
    /**
     * Specifies whether the address passed to the parameter at the specified index is retained after
     * the function returns. The result is given as a `ParameterEscape` object. See the comments for
     * that class and its subclasses for a description of each possible result.
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
     * - `getParameterEscapeBehavior(0) instanceof Escapes`
     * - `getParameterEscapeBehavior(1) instanceof EscapesOnlyViaReturn`
     * - `getParameterEscapeBehavior(2) instanceof EscapesOnlyViaReturn`
     * - `getParameterEscapeBehavior(3) instanceof DoesNotEscape`
     */
    abstract ParameterEscape getParameterEscapeBehavior(int index);

    /**
     * Holds if the function always returns the value of the parameter at the specified index.
     */
    abstract predicate parameterIsAlwaysReturned(int index);
  }

  /**
    * Specifies whether the address passed to the parameter at the specified index is retained after
    * the function returns. The result is given as a `ParameterEscape` object. See the comments for
    * that class and its subclasses for a description of each possible result.
    */
  ParameterEscape getParameterEscapeBehavior(Function f, int index) {
    result = f.(AliasFunction).getParameterEscapeBehavior(index) or
    (
      not f instanceof AliasFunction and
      exists(f.getParameter(index)) and
      result instanceof Escapes
    )
  }

  /**
    * Holds if the function always returns the value of the parameter at the specified index.
    */
  predicate parameterIsAlwaysReturned(Function f, int index) {
    f.(AliasFunction).parameterIsAlwaysReturned(index)
  }
}