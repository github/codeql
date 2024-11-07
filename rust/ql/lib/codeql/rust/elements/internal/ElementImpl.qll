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
    override string toString() { result = this.getAPrimaryQlClass() }

    predicate isUnknown() { none() } // compatibility with test generation, to be fixed
  }
}
