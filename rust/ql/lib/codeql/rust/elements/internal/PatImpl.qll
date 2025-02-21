/**
 * This module provides a hand-modifiable wrapper around the generated class `Pat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Pat
private import codeql.rust.elements.internal.generated.ParentChild

/**
 * INTERNAL: This module contains the customizable definition of `Pat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * The base class for patterns.
   */
  class Pat extends Generated::Pat {
    /**
     * Gets the pattern under which this pattern is immediately nested, if any.
     */
    Pat getParentPat() {
      result = getImmediateParent(this)
      or
      result.(RecordPat).getRecordPatFieldList().getAField().getPat() = this
    }
  }
}
