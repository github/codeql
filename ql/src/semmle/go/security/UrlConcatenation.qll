/**
 * Provides a class for detecting string concatenations involving
 * the characters `?` and `#`, which are considered sanitizers for
 * the URL redirection queries.
 */

import go

/**
 * Holds if the string value of `cat` prevents anything appended after it
 * from affecting the hostname or path of a URL.
 *
 * Specifically, this holds if the string contains `?` or `#`.
 */
private predicate concatenationHasSanitizingSubstring(StringOps::ConcatenationElement cat) {
  exists(StringOps::ConcatenationLeaf lf | lf = cat.getALeaf() |
    lf.getStringValue().regexpMatch(".*[?#].*")
    or
    hasSanitizingSubstring(lf.asNode().getAPredecessor())
  )
}

/**
 * Holds if the string value of `nd` prevents anything appended after it
 * from affecting the hostname or path of a URL.
 *
 * Specifically, this holds if the string contains `?` or `#`.
 */
private predicate hasSanitizingSubstring(DataFlow::Node nd) {
  exists(StringOps::ConcatenationElement cat | nd = cat.asNode() |
    concatenationHasSanitizingSubstring(cat)
  )
  or
  hasSanitizingSubstring(nd.getAPredecessor())
}

/**
 * Holds if data that flows from `source` to `sink` cannot affect the
 * path or earlier part of the resulting string when interpreted as a URL.
 *
 * This is considered as a sanitizing edge for the URL redirection queries.
 */
predicate sanitizingPrefixEdge(DataFlow::Node source, DataFlow::Node sink) {
  exists(StringOps::ConcatenationElement cat, int n |
    StringOps::Concatenation::taintStep(source, sink, cat.asNode(), n) and
    concatenationHasSanitizingSubstring(cat.getOperand([0 .. n - 1]))
  )
}

/**
 * Holds if the string value of `cat` prevents anything appended after it
 * from affecting the hostname of a URL.
 */
private predicate concatenationHasHostnameSanitizingSubstring(StringOps::ConcatenationElement cat) {
  exists(StringOps::ConcatenationLeaf lf | lf = cat.getALeaf() |
    lf.getStringValue().regexpMatch(".*([?#]|[^?#:/\\\\][/\\\\]).*|[/\\\\][^/\\\\].*")
    or
    // this deals with cases such as `Sprintf("%s/%s", hostname, taint)`, which should be safe as
    // long as `hostname` is not user-controlled
    lf.getStringValue() = "/" and
    exists(lf.getPreviousLeaf())
    or
    hasHostnameSanitizingSubstring(lf.asNode())
  )
}

/**
 * Holds if the string value of `nd` prevents anything appended after it
 * from affecting the hostname of a URL.
 *
 * Specifically, this holds if the string contains any of the following:
 * - `?` (any suffix becomes part of query)
 * - `#` (any suffix becomes part of fragment)
 * - `/` or `\`, immediately prefixed by a character other than `:`, `/`, or `\` (any suffix becomes part of the path)
 * - a leading `/` or `\` followed by a character other than `/` or `\` (any suffix becomes part of the path)
 *
 * In the latter two cases, the additional check is necessary to avoid a `/` that could be interpreted as
 * the `//` separating the (optional) scheme from the hostname.
 */
predicate hasHostnameSanitizingSubstring(DataFlow::Node nd) {
  exists(StringOps::ConcatenationElement cat | cat.asNode() = nd |
    concatenationHasHostnameSanitizingSubstring(cat)
  )
  or
  hasHostnameSanitizingSubstring(nd.getAPredecessor())
}

/**
 * Holds if data that flows from `source` to `sink` cannot affect the
 * hostname or scheme of the resulting string when interpreted as a URL.
 *
 * This is considered as a sanitizing edge for the URL redirection queries.
 */
predicate hostnameSanitizingPrefixEdge(DataFlow::Node source, DataFlow::Node sink) {
  exists(StringOps::ConcatenationElement cat, int n |
    StringOps::Concatenation::taintStep(source, sink, cat.asNode(), n) and
    concatenationHasHostnameSanitizingSubstring(cat.getOperand([0 .. n - 1]))
  )
}
