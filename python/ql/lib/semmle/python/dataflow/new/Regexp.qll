/**
 * Provides classes for working with regular expressions.
 */

private import semmle.python.RegexTreeView
private import semmle.python.regex
private import semmle.python.dataflow.new.DataFlow

/**
 * Provides utility predicates related to regular expressions.
 */
module RegExpPatterns {
  /**
   * Gets a pattern that matches common top-level domain names in lower case.
   */
  string getACommonTld() {
    // according to ranking by http://google.com/search?q=site:.<<TLD>>
    result = "(?:com|org|edu|gov|uk|net|io)(?![a-z0-9])"
  }
}

/**
 * A node whose value may flow to a position where it is interpreted
 * as a part of a regular expression.
 */
class RegExpPatternSource extends DataFlow::CfgNode {
  private Regex astNode;

  RegExpPatternSource() { astNode = this.asExpr() }

  /**
   * Gets a node where the pattern of this node is parsed as a part of
   * a regular expression.
   */
  DataFlow::Node getAParse() { result = this }

  /**
   * Gets the root term of the regular expression parsed from this pattern.
   */
  RegExpTerm getRegExpTerm() { result.getRegex() = astNode }
}
