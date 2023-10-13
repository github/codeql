/**
 * Provides a class for detecting string concatenations involving
 * the characters `?` and `#`, which are considered sanitizers for
 * the URL redirection queries.
 */

import ruby
import codeql.ruby.StringOps
import codeql.ruby.StringConcatenation

private StringConcatenation::Operand getAnOperandPredecessor(StringConcatenation::Operand op) {
  result.asDataFlowNode() = op.asDataFlowNode().getAPredecessor()
}

/**
 * Holds if the string value of `op` prevents anything appended after it
 * from affecting the hostname or path of a URL.
 *
 * Specifically, this holds if the string contains `?` or `#`.
 */
private predicate hasSanitizingSubstring(StringConcatenation::Operand op) {
  op.getConstantValue().getStringlikeValue().regexpMatch(".*[?#].*")
  or
  hasSanitizingSubstring(StringConcatenation::getAnOperand(op.asDataFlowNode()))
  or
  hasSanitizingSubstring(getAnOperandPredecessor(op))
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
    hasSanitizingSubstring(StringConcatenation::getOperand(operator, [0 .. n - 1]))
  )
}

/**
 * Holds if the string value of `op` prevents anything appended after it
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
private predicate hasHostnameSanitizingSubstring(StringConcatenation::Operand op) {
  op.getConstantValue()
      .getStringlikeValue()
      .regexpMatch(".*([?#]|[^?#:/\\\\][/\\\\]).*|[/\\\\][^/\\\\].*")
  or
  hasHostnameSanitizingSubstring(StringConcatenation::getAnOperand(op.asDataFlowNode()))
  or
  hasHostnameSanitizingSubstring(getAnOperandPredecessor(op))
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
predicate hostnameGuard(Cfg::CfgNodes::AstCfgNode g, Cfg::CfgNode e, boolean branch) {
  exists(StringOps::StartsWith startsWith, StringConcatenation::Operand substringOp |
    substringOp.asDataFlowNode() = startsWith.getSubstring()
  |
    hasHostnameSanitizingSubstring(substringOp) and
    g = startsWith.asExpr() and
    branch = startsWith.getPolarity() and
    e = startsWith.getBaseString().asExpr()
  )
}
