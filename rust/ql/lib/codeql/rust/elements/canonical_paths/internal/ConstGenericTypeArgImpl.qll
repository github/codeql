/**
 * This module provides a hand-modifiable wrapper around the generated class `ConstGenericTypeArg`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.ConstGenericTypeArg

/**
 * INTERNAL: This module contains the customizable definition of `ConstGenericTypeArg` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A generic argument for a type that is a const.
   */
  class ConstGenericTypeArg extends Generated::ConstGenericTypeArg {
    override string toString() { result = "const ?" }

    override string toAbbreviatedString() { result = "?" }
  }
}
