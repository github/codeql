/**
 * This module provides a hand-modifiable wrapper around the generated class `UseTreeList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.UseTreeList

/**
 * INTERNAL: This module contains the customizable definition of `UseTreeList` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A list of use trees in a use declaration.
   *
   * For example:
   * ```rust
   * use std::{fs, io};
   * //       ^^^^^^^^
   * ```
   */
  class UseTreeList extends Generated::UseTreeList {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
