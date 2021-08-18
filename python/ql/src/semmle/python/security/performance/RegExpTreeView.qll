/**
 * This module should provide a class hierarchy corresponding to a parse tree of regular expressions.
 */

import python
import semmle.python.RegexTreeView

/**
 * Holds if the regular expression should not be considered.
 *
 * We make the pragmatic performance optimization to ignore regular expressions in files
 * that does not belong to the project code (such as installed dependencies).
 */
predicate isExcluded(RegExpParent parent) {
  not exists(parent.getRegex().getLocation().getFile().getRelativePath())
}
