/**
 * This module provides a hand-modifiable wrapper around the generated class `TypeGenericTypeArg`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.TypeGenericTypeArg

/**
 * INTERNAL: This module contains the customizable definition of `TypeGenericTypeArg` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A generic argument for a type that is a type.
   */
  class TypeGenericTypeArg extends Generated::TypeGenericTypeArg {
    override string toString() { result = this.getPath().toAbbreviatedString() }
  }
}
