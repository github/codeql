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
  exists (Expr e | e = nd.asExpr() |
    (e instanceof AddExpr or e instanceof AssignAddExpr) and
    hasSanitizingSubstring(DataFlow::valueNode(e.getAChildExpr()))
    or
    e.getStringValue().regexpMatch(".*[?#].*")
  )
  or
  nd.isIncomplete(_)
  or
  hasSanitizingSubstring(nd.getAPredecessor())
}

/**
 * Holds if data that flows from `source` to `sink` may have a string
 * containing the character `?` or `#` prepended to it.
 *
 * This is considered as a sanitizing edge for the URL redirection queries.
 */
predicate sanitizingPrefixEdge(DataFlow::Node source, DataFlow::Node sink) {
  exists (AddExpr add, DataFlow::Node left |
    source.asExpr() = add.getRightOperand() and
    sink.asExpr() = add and
    left.asExpr() = add.getLeftOperand() and
    hasSanitizingSubstring(left)
  )
  or
  exists (TemplateLiteral tl, int i, DataFlow::Node elt |
    source.asExpr() = tl.getElement(i) and
    sink.asExpr() = tl and
    elt.asExpr() = tl.getElement([0..i-1]) and
    hasSanitizingSubstring(elt)
  )
}
