/**
 * This module provides a hand-modifiable wrapper around the generated class `Path`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Path

/**
 * INTERNAL: This module contains the customizable definition of `Path` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A path. For example:
   * ```rust
   * use some_crate::some_module::some_item;
   * foo::bar;
   * ```
   */
  class Path extends Generated::Path {
    override string toStringImpl() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() {
      result = strictconcat(int i | | this.toAbbreviatedStringPart(i) order by i)
    }

    private string toAbbreviatedStringPart(int index) {
      index = 0 and
      this.hasQualifier() and
      result = "...::"
      or
      index = 1 and
      result = this.getSegment().toAbbreviatedString()
    }

    /**
     * Gets the text of this path, if it exists.
     */
    pragma[nomagic]
    string getText() { result = this.getSegment().getIdentifier().getText() }
  }

  /** A simple identifier path. */
  class IdentPath extends Path {
    private string name;

    IdentPath() {
      not this.hasQualifier() and
      exists(PathSegment ps |
        ps = this.getSegment() and
        not ps.hasGenericArgList() and
        not ps.hasParenthesizedArgList() and
        not ps.hasTypeRepr() and
        not ps.hasReturnTypeSyntax() and
        name = ps.getIdentifier().getText()
      )
    }

    /** Gets the identifier name. */
    string getName() { result = name }
  }
}
