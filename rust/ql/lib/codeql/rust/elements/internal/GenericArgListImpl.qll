/**
 * This module provides a hand-modifiable wrapper around the generated class `GenericArgList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.GenericArgList

/**
 * INTERNAL: This module contains the customizable definition of `GenericArgList` and should not
 * be referenced directly.
 */
module Impl {
  private import rust

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * The base class for generic arguments.
   * ```rust
   * x.foo::<u32, u64>(42);
   * ```
   */
  class GenericArgList extends Generated::GenericArgList {
    override string toStringImpl() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = "<...>" }

    /** Gets the `i`th type argument of this list. */
    TypeRepr getTypeArg(int i) {
      result =
        rank[i + 1](TypeRepr res, int j |
          res = this.getGenericArg(j).(TypeArg).getTypeRepr()
        |
          res order by j
        )
    }

    /** Gets a type argument of this list. */
    TypeRepr getATypeArg() { result = this.getTypeArg(_) }

    /** Gets the associated type argument with the given `name`, if any. */
    pragma[nomagic]
    TypeRepr getAssocTypeArg(string name) {
      exists(AssocTypeArg arg |
        arg = this.getAGenericArg() and
        result = arg.getTypeRepr() and
        name = arg.getIdentifier().getText()
      )
    }
  }
}
