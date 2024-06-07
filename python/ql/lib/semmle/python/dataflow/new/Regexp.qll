/**
 * Provides classes for working with regular expressions.
 */

private import semmle.python.regexp.RegexTreeView
private import semmle.python.regex
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.regexp.internal.RegExpTracking

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
