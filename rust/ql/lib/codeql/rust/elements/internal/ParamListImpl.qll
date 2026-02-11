/**
 * This module provides a hand-modifiable wrapper around the generated class `ParamList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ParamList

/**
 * INTERNAL: This module contains the customizable definition of `ParamList` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A list of parameters in a function, method, or closure declaration.
   *
   * For example:
   * ```rust
   * fn foo(x: i32, y: i32) {}
   * //      ^^^^^^^^^^^^^
   * ```
   */
  class ParamList extends Generated::ParamList {
    /**
     * Gets any of the parameters of this parameter list.
     */
    final ParamBase getAParamBase() { result = this.getParam(_) or result = this.getSelfParam() }
  }
}
