/**
 * Provides Python-specific definitions for use in the ReDoSUtil module.
 */

import python
import semmle.python.RegexTreeView

/**
 * Holds if `term` is an ecape class representing e.g. `\d`.
 * `clazz` is which character class it represents, e.g. "d" for `\d`.
 */
predicate isEscapeClass(RegExpTerm term, string clazz) {
  exists(RegExpCharacterClassEscape escape | term = escape | escape.getValue() = clazz)
}

/**
 * Holds if the regular expression should not be considered.
 *
 * We make the pragmatic performance optimization to ignore regular expressions in files
 * that does not belong to the project code (such as installed dependencies).
 */
predicate isExcluded(RegExpParent parent) {
  not exists(parent.getRegex().getLocation().getFile().getRelativePath())
  or
  // Regexes with many occurrences of ".*" may cause the polynomial ReDoS computation to explode, so
  // we explicitly exclude these.
  count(int i | exists(parent.getRegex().getText().regexpFind("\\.\\*", i, _)) | i) > 10
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
