/**
 * Provides models for miscellaneous utility functions in the closure standard library.
 */

import javascript

module ClosureLibrary {
  private import DataFlow

  private class StringStep extends TaintTracking::SharedTaintStep {
    override predicate step(Node pred, Node succ) {
      exists(string name, CallNode call |
        call = Closure::moduleImport("goog.string." + name).getACall() and succ = call
      |
        pred = call.getAnArgument() and
        name =
          [
            "canonicalizeNewlines", //
            "capitalize", //
            "collapseBreakingSpaces", //
            "collapseWhitespace", //
            "format", //
            "makeSafe", // makeSafe just guards against null and undefined
            "newLineOrBr", //
            "normalizeSpaces", //
            "normalizeWhitespace", //
            "preserveSpaces", //
            "remove", // removes first occurrence of a substring
            "repeat", //
            "splitLimit", //
            "stripNewlines", //
            "subs", //
            "toCamelCase", //
            "toSelectorCase", //
            "toTitleCase", //
            "trim", //
            "trimLeft", //
            "trimRight", //
            "unescapeEntities", //
            "whitespaceEscape"
          ]
        or
        pred = call.getArgument(0) and
        name =
          [
            "truncate", //
            "truncateMiddle", //
            "unescapeEntitiesWithDocument", //
          ]
      )
    }
  }
}
