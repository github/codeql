/**
 * This module should provide a class hierarchy corresponding to a parse tree of regular expressions.
 *
 * Since the javascript extractor already provides such a hierarchy, we simply import that.
 */

import javascript

/**
 * Holds if the regular expression should not be considered.
 *
 * For javascript we make the pragmatic performance optimization to ignore minified files.
 */
predicate isExcluded(RegExpParent parent) { parent.(Expr).getTopLevel().isMinified() }

/**
 * A module containing predicates for determining which flags a regular expression have.
 */
module RegExpFlags {
  /**
   * Holds if `root` has the `i` flag for case-insensitive matching.
   */
  predicate isIgnoreCase(RegExpTerm root) {
    root.isRootTerm() and
    exists(DataFlow::RegExpCreationNode node | node.getRoot() = root |
      RegExp::isIgnoreCase(node.getFlags())
    )
  }

  /**
   * Gets the flags for `root`, or the empty string if `root` has no flags.
   */
  string getFlags(RegExpTerm root) {
    root.isRootTerm() and
    exists(DataFlow::RegExpCreationNode node | node.getRoot() = root |
      result = node.getFlags()
      or
      not exists(node.getFlags()) and
      result = ""
    )
  }

  /**
   * Holds if `root` has the `s` flag for multi-line matching.
   */
  predicate isDotAll(RegExpTerm root) {
    root.isRootTerm() and
    exists(DataFlow::RegExpCreationNode node | node.getRoot() = root |
      RegExp::isDotAll(node.getFlags())
    )
  }
}
