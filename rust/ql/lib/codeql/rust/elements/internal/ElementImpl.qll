/**
 * This module provides a hand-modifiable wrapper around the generated class `Element`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Element

/**
 * INTERNAL: This module contains the customizable definition of `Element` and should not
 * be referenced directly.
 */
module Impl {
  class Element extends Generated::Element {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }

    /**
     * INTERNAL: Do not use.
     *
     * Returns a string suitable to be inserted into the name of the parent. Typically `"..."`,
     * but may be overridden by subclasses.
     */
    string toAbbreviatedString() { result = "..." }

    predicate isUnknown() { none() } // compatibility with test generation, to be fixed
  }
}
