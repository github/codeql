/**
 * This module should provide a class hierarchy corresponding to a parse tree of regular expressions.
 */

import python
import semmle.python.RegexTreeView

// pragmatic performance optimization: ignore files we did not extract.
predicate isExcluded(RegExpParent parent) {
  not exists(parent.getRegex().getLocation().getFile().getRelativePath())
}
