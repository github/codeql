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
  private import rust
  private import codeql.rust.elements.internal.generated.ParentChild
  private import codeql.rust.elements.internal.generated.Synth
  private import codeql.rust.elements.internal.generated.Raw
  private import codeql.rust.elements.internal.LocationImpl

  /**
   * Provides logic for classifying elements with respect to macro expansions.
   */
  cached
  module MacroExpansion {
    /**
     * Holds if `e` is superseded by an attribute macro expansion. That is, `e` is
     * a transitive child of an item with an attribute macro expansion.
     *
     * Since this predicate is referenced in the charpred of `Element`, we need to
     * use the parent-child relation on raw elements to avoid non-monotonicity.
     */
    private predicate supersededByAttributeMacroExpansionRaw(Raw::Item item, Raw::Element e) {
      exists(item.getAttributeMacroExpansion()) and
      e = Raw::getImmediateChild(item, _) and
      not e = item.getAttributeMacroExpansion() and
      // Don't consider attributes themselves to be superseded.  E.g., in `#[a] fn
      // f() {}` the macro expansion supersedes `fn f() {}` but not `#[a]`.
      not e instanceof Raw::Attr
      or
      exists(Raw::Element parent |
        e = Raw::getImmediateChild(parent, _) and
        supersededByAttributeMacroExpansionRaw(item, parent)
      )
    }

    private predicate isMacroExpansion(AstNode macro, AstNode expansion) {
      expansion = macro.(MacroCall).getMacroCallExpansion()
      or
      expansion = macro.(TypeItem).getDeriveMacroExpansion(_)
      or
      expansion = macro.(Item).getAttributeMacroExpansion()
    }

    /**
     * Gets the immediately enclosing macro invocation for element `e`, if any.
     *
     * The result is either a `MacroCall`, an `Adt` with a derive macro expansion, or
     * an `Item` with an attribute macro expansion.
     */
    cached
    AstNode getImmediatelyEnclosingMacroInvocation(Element e) {
      isMacroExpansion(result, e)
      or
      exists(Element mid |
        result = getImmediatelyEnclosingMacroInvocation(mid) and
        mid = getImmediateParent(e) and
        not isMacroExpansion(mid, e)
      )
    }

    pragma[nomagic]
    private predicate isAttributeMacroExpansionSourceLocation(Item i, Location l) {
      exists(Raw::Locatable e, @location_default loc |
        supersededByAttributeMacroExpansionRaw(Synth::convertElementToRaw(i), e) and
        locatable_locations(e, loc) and
        l = LocationImpl::TLocationDefault(loc)
      )
    }

    /** Gets an AST node whose location is inside the token tree belonging to `mc`. */
    pragma[nomagic]
    private AstNode getATokenTreeNode(MacroCall mc) {
      mc = getImmediatelyEnclosingMacroInvocation(result) and
      mc.getTokenTree().getLocation().contains(result.getLocation())
    }

    /** Holds if `n` is inside a macro expansion. */
    cached
    predicate isInMacroExpansion(AstNode n) { exists(getImmediatelyEnclosingMacroInvocation(n)) }

    /**
     * Holds if `n` exists only as the result of a macro expansion.
     *
     * This is the same as `isInMacroExpansion(n)`, but excludes AST nodes corresponding
     * to macro arguments, including attribute macro targets.
     *
     * Note: This predicate is a heuristic based on location information and may not be
     * accurate in all cases.
     */
    cached
    predicate isFromMacroExpansion(AstNode n) {
      exists(AstNode macro, Location l |
        macro = getImmediatelyEnclosingMacroInvocation(n) and
        not n = getATokenTreeNode(macro) and
        l = n.getLocation() and
        not isAttributeMacroExpansionSourceLocation(macro, l)
      )
      or
      isFromMacroExpansion(pragma[only_bind_into](getImmediatelyEnclosingMacroInvocation(n)))
    }

    cached
    predicate isRelevantElement(Generated::Element e) {
      exists(Raw::Element raw |
        raw = Synth::convertElementToRaw(e) and
        not supersededByAttributeMacroExpansionRaw(_, raw)
      )
      or
      // Synthetic elements are relevant when their parents are
      Synth::convertFormatArgsExprToRaw(_) = Synth::getSynthParent(e)
    }
  }

  class Element extends Generated::Element {
    Element() { MacroExpansion::isRelevantElement(this) }

    override string toStringImpl() { result = this.getAPrimaryQlClass() }

    /**
     * INTERNAL: Do not use.
     *
     * Returns a string suitable to be inserted into the name of the parent. Typically `"..."`,
     * but may be overridden by subclasses.
     */
    pragma[nomagic]
    string toAbbreviatedString() { result = "..." }

    predicate isUnknown() { none() } // compatibility with test generation, to be fixed
  }
}
