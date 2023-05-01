/**
 * Provides classes for working with regular expressions.
 */

private import semmle.python.regexp.RegexTreeView
private import semmle.python.regex
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.regexp.internal.RegExpTracking

/**
 * Provides utility predicates related to regular expressions.
 */
deprecated module RegExpPatterns {
  /**
   * Gets a pattern that matches common top-level domain names in lower case.
   * DEPRECATED: use the similarly named predicate from `HostnameRegex` from the `regex` pack instead.
   */
  deprecated string getACommonTld() {
    // according to ranking by http://google.com/search?q=site:.<<TLD>>
    result = "(?:com|org|edu|gov|uk|net|io)(?![a-z0-9])"
  }
}

/**
 * A node whose value may flow to a position where it is interpreted
 * as a part of a regular expression.
 */
class RegExpPatternSource extends DataFlow::CfgNode {
  private RegExpSink sink;

  RegExpPatternSource() { this = regExpSource(sink) }

  /**
   * Gets a node where the pattern of this node is parsed as a part of
   * a regular expression.
   */
  RegExpSink getAParse() { result = sink }

  /**
   * Gets the root term of the regular expression parsed from this pattern.
   */
  RegExpTerm getRegExpTerm() { result.getRegex() = this.asExpr() }
}
