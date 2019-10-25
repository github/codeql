/**
 * Provides models for miscellaneous utility functions in the closure standard library.
 */

import javascript

module ClosureLibrary {
  private import DataFlow

  private class StringStep extends TaintTracking::AdditionalTaintStep, CallNode {
    Node pred;

    StringStep() {
      exists(string name | this = Closure::moduleImport("goog.string." + name).getACall() |
        pred = getAnArgument() and
        (
          name = "canonicalizeNewlines" or
          name = "capitalize" or
          name = "collapseBreakingSpaces" or
          name = "collapseWhitespace" or
          name = "format" or
          name = "makeSafe" or // makeSafe just guards against null and undefined
          name = "newLineOrBr" or
          name = "normalizeSpaces" or
          name = "normalizeWhitespace" or
          name = "preserveSpaces" or
          name = "remove" or // removes first occurrence of a substring
          name = "repeat" or
          name = "splitLimit" or
          name = "stripNewlines" or
          name = "subs" or
          name = "toCamelCase" or
          name = "toSelectorCase" or
          name = "toTitleCase" or
          name = "trim" or
          name = "trimLeft" or
          name = "trimRight" or
          name = "unescapeEntities" or
          name = "whitespaceEscape"
        )
        or
        pred = getArgument(0) and
        (
          name = "truncate" or
          name = "truncateMiddle" or
          name = "unescapeEntitiesWithDocument"
        )
      )
    }

    override predicate step(Node src, Node dst) {
      src = pred and
      dst = this
    }
  }
}
