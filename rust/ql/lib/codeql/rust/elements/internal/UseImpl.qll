/**
 * This module provides a hand-modifiable wrapper around the generated class `Use`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Use

/**
 * INTERNAL: This module contains the customizable definition of `Use` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A `use` statement. For example:
   * ```rust
   * use std::collections::HashMap;
   * ```
   */
  class Use extends Generated::Use {
    override string toStringImpl() { result = "use " + this.getUseTree().toAbbreviatedString() }
  }
}
