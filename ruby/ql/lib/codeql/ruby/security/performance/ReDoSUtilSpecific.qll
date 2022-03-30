/**
 * Provides Ruby-specific definitions for use in the ReDoSUtil module.
 */

import codeql.ruby.Regexp
import codeql.Locations
private import codeql.ruby.ast.Literal as AST

/**
 * Holds if `term` is an ecape class representing e.g. `\d`.
 * `clazz` is which character class it represents, e.g. "d" for `\d`.
 */
predicate isEscapeClass(RegExpTerm term, string clazz) {
  exists(RegExpCharacterClassEscape escape | term = escape | escape.getValue() = clazz)
  or
  // TODO: expand to cover more properties
  exists(RegExpNamedCharacterProperty escape | term = escape |
    escape.getName().toLowerCase() = "digit" and
    if escape.isInverted() then clazz = "D" else clazz = "d"
    or
    escape.getName().toLowerCase() = "space" and
    if escape.isInverted() then clazz = "S" else clazz = "s"
    or
    escape.getName().toLowerCase() = "word" and
    if escape.isInverted() then clazz = "W" else clazz = "w"
  )
}

/**
 * Holds if the regular expression should not be considered.
 */
predicate isExcluded(RegExpParent parent) {
  parent.(RegExpTerm).getRegExp().(AST::RegExpLiteral).hasFreeSpacingFlag() // exclude free-spacing mode regexes
}

/**
 * A module containing predicates for determining which flags a regular expression have.
 */
module RegExpFlags {
  /**
   * Holds if `root` has the `i` flag for case-insensitive matching.
   */
  predicate isIgnoreCase(RegExpTerm root) {
    root.isRootTerm() and
    root.getLiteral().isIgnoreCase()
  }

  /**
   * Gets the flags for `root`, or the empty string if `root` has no flags.
   */
  string getFlags(RegExpTerm root) {
    root.isRootTerm() and
    result = root.getLiteral().getFlags()
  }

  /**
   * Holds if `root` has the `s` flag for multi-line matching.
   */
  predicate isDotAll(RegExpTerm root) {
    root.isRootTerm() and
    root.getLiteral().isDotAll()
  }
}
