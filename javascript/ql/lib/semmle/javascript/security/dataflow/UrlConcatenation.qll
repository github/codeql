/**
 * Provides a class for detecting string concatenations involving
 * the characters `?` and `#`, which are considered sanitizers for
 * the URL redirection queries.
 */

import javascript

/**
 * Holds if the given data flow node may refer to a string for which we have incomplete information.
 */
private predicate hasIncompleteSubstring(DataFlow::Node nd) {
  nd.isIncomplete(_)
  or
  hasIncompleteSubstring(StringConcatenation::getAnOperand(nd))
  or
  hasIncompleteSubstring(nd.getAPredecessor())
}

/**
 * Holds if the given data flow node refers to a string that ends with a slash.
 */
private predicate endsWithSlash(DataFlow::Node nd) {
  nd.getStringValue().matches("%/")
  or
  endsWithSlash(StringConcatenation::getLastOperand(nd))
}

/**
 * Holds if the string value of `nd` prevents anything appended after it
 * from affecting the hostname or path of a URL.
 *
 * Specifically, this holds if the string contains `?` or `#`.
 */
private predicate hasSanitizingSubstring(DataFlow::Node nd) {
  nd.getStringValue().regexpMatch(".*[?#].*")
  or
  hasSanitizingSubstring(StringConcatenation::getAnOperand(nd))
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
  exists(DataFlow::Node operator, int n |
    StringConcatenation::taintStep(source, sink, operator, n) and
    (
      hasSanitizingSubstring(StringConcatenation::getOperand(operator, [0 .. n - 1]))
      or
      // If prefixed by an unknown base URL, assume the URL is safe, unless
      // separated by a slash, such as `${baseUrl}/${taint}`. The slash is a
      // good indicator that the incoming value is most likely part of the path.
      hasIncompleteSubstring(StringConcatenation::getOperand(operator, [0 .. n - 1])) and
      not endsWithSlash(StringConcatenation::getOperand(operator, n - 1))
    )
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
private predicate hasHostnameSanitizingSubstring(DataFlow::Node nd) {
  nd.getStringValue().regexpMatch(".*([?#]|[^?#:/\\\\][/\\\\]).*|[/\\\\][^/\\\\].*")
  or
  hasHostnameSanitizingSubstring(StringConcatenation::getAnOperand(nd))
  or
  hasHostnameSanitizingSubstring(nd.getAPredecessor())
  or
  nd.isIncomplete(_)
}

/**
 * Holds if data that flows from `source` to `sink` cannot affect the
 * hostname or scheme of the resulting string when interpreted as a URL.
 *
 * This is considered as a sanitizing edge for the URL redirection queries.
 */
predicate hostnameSanitizingPrefixEdge(DataFlow::Node source, DataFlow::Node sink) {
  exists(DataFlow::Node operator, int n |
    StringConcatenation::taintStep(source, sink, operator, n) and
    hasHostnameSanitizingSubstring(StringConcatenation::getOperand(operator, [0 .. n - 1]))
  )
}

/**
 * A check that sanitizes the hostname of a URL.
 */
class HostnameSanitizerGuard extends StringOps::StartsWith {
  HostnameSanitizerGuard() { hasHostnameSanitizingSubstring(this.getSubstring()) }

  /** DEPRECATED. Use `blocksExpr` instead. */
  deprecated predicate sanitizes(boolean outcome, Expr e) { this.blocksExpr(outcome, e) }

  /** Holds if this node blocks flow through `e`, provided it evaluates to `outcome`. */
  predicate blocksExpr(boolean outcome, Expr e) {
    outcome = this.getPolarity() and
    e = this.getBaseString().asExpr()
  }
}

deprecated private class HostnameSanitizerGuardLegacy extends TaintTracking::SanitizerGuardNode instanceof HostnameSanitizerGuard
{
  override predicate sanitizes(boolean outcome, Expr e) {
    HostnameSanitizerGuard.super.sanitizes(outcome, e)
  }
}

/**
 * A check that sanitizes the hostname of a URL.
 */
module HostnameSanitizerGuard = DataFlow::MakeBarrierGuard<HostnameSanitizerGuard>;
