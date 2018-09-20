/**
 * Provides a class for detecting string concatenations involving
 * the characters `?` and `#`, which are considered sanitizers for
 * the URL redirection queries.
 */

import javascript

/**
 * Holds if a string value containing `?` or `#` may flow into
 * `nd` or one of its operands, assuming that it is a concatenation.
 */
private predicate hasSanitizingSubstring(DataFlow::Node nd) {
  nd.asExpr().getStringValue().regexpMatch(".*[?#].*")
  or
  hasSanitizingSubstring(StringConcatenation::getAnOperand(nd))
  or
  hasSanitizingSubstring(nd.getAPredecessor())
  or
  nd.isIncomplete(_)
}

/**
 * Holds if data that flows from `source` to `sink` may have a string
 * containing the character `?` or `#` prepended to it.
 *
 * This is considered as a sanitizing edge for the URL redirection queries.
 */
predicate sanitizingPrefixEdge(DataFlow::Node source, DataFlow::Node sink) {
  exists (DataFlow::Node operator, int n |
    StringConcatenation::taintStep(source, sink, operator, n) and
    hasSanitizingSubstring(StringConcatenation::getOperand(operator, [0..n-1])))
}
