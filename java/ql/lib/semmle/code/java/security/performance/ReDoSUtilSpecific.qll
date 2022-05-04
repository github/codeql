/**
 * This module should provide a class hierarchy corresponding to a parse tree of regular expressions.
 * This is the interface to the shared ReDoS library.
 */

private import java
import semmle.code.FileSystem
import semmle.code.java.regex.RegexTreeView

/**
 * Holds if `term` is an escape class representing e.g. `\d`.
 * `clazz` is which character class it represents, e.g. "d" for `\d`.
 */
predicate isEscapeClass(RegExpTerm term, string clazz) {
  term.(RegExpCharacterClassEscape).getValue() = clazz
  or
  term.(RegExpNamedProperty).getBackslashEquivalent() = clazz
}

/**
 * Holds if `term` is a possessive quantifier, e.g. `a*+`.
 */
predicate isPossessive(RegExpQuantifier term) { term.isPossessive() }

/**
 * Holds if the regex that `term` is part of is used in a way that ignores any leading prefix of the input it's matched against.
 */
predicate matchesAnyPrefix(RegExpTerm term) { not term.getRegex().matchesFullString() }

/**
 * Holds if the regex that `term` is part of is used in a way that ignores any trailing suffix of the input it's matched against.
 */
predicate matchesAnySuffix(RegExpTerm term) { not term.getRegex().matchesFullString() }

/**
 * Holds if the regular expression should not be considered.
 *
 * We make the pragmatic performance optimization to ignore regular expressions in files
 * that do not belong to the project code (such as installed dependencies).
 */
predicate isExcluded(RegExpParent parent) {
  not exists(parent.getRegex().getLocation().getFile().getRelativePath())
  or
  // Regexes with many occurrences of ".*" may cause the polynomial ReDoS computation to explode, so
  // we explicitly exclude these.
  strictcount(int i | exists(parent.getRegex().getText().regexpFind("\\.\\*", i, _)) | i) > 10
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
