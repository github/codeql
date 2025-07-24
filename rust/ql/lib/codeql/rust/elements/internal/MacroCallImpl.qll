/**
 * This module provides a hand-modifiable wrapper around the generated class `MacroCall`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.MacroCall

/**
 * INTERNAL: This module contains the customizable definition of `MacroCall` and should not
 * be referenced directly.
 */
module Impl {
  private import rust

  pragma[nomagic]
  predicate isInMacroExpansion(AstNode root, AstNode n) {
    n = root.(MacroCall).getMacroCallExpansion()
    or
    n = root.(Adt).getDeriveMacroExpansion(_)
    or
    isInMacroExpansion(root, n.getParentNode())
  }

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A macro invocation.
   *
   * For example:
   * ```rust
   * println!("Hello, world!");
   * ```
   */
  class MacroCall extends Generated::MacroCall {
    override string toStringImpl() {
      if this.hasPath() then result = this.getPath().toAbbreviatedString() + "!..." else result = ""
    }

    /** Gets an AST node whose location is inside the token tree belonging to this macro call. */
    pragma[nomagic]
    AstNode getATokenTreeNode() {
      isInMacroExpansion(this, result) and
      this.getTokenTree().getLocation().contains(result.getLocation())
    }
  }
}
