/**
 * This module provides a hand-modifiable wrapper around the generated class `Callable`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Callable

/**
 * INTERNAL: This module contains the customizable definition of `Callable` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A callable. Either a `Function` or a `ClosureExpr`.
   */
  class Callable extends Generated::Callable {
    override Param getParam(int index) { result = this.getParamList().getParam(index) }

    /**
     * Gets the self parameter of this callable, if it exists.
     */
    SelfParam getSelfParam() { result = this.getParamList().getSelfParam() }

    /**
     * Holds if `getSelfParam()` exists.
     */
    predicate hasSelfParam() { exists(this.getSelfParam()) }

    /**
     * Gets the number of parameters of this callable, including `self` if it exists.
     */
    int getNumberOfParamsInclSelf() {
      exists(int arr |
        arr = this.getNumberOfParams() and
        if this.hasSelfParam() then result = arr + 1 else result = arr
      )
    }
  }
}
