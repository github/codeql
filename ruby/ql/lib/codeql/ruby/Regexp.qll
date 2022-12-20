/**
 * Provides classes for working with regular expressions.
 *
 * Regular expression literals are represented as an abstract syntax tree of regular expression
 * terms.
 */

import regexp.RegExpTreeView // re-export
private import regexp.internal.ParseRegExp
private import regexp.internal.RegExpConfiguration
private import codeql.ruby.ast.Literal as Ast
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs

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
abstract class RegExpPatternSource extends DataFlow::Node {
  /**
   * Gets a node where the pattern of this node is parsed as a part of
   * a regular expression.
   */
  abstract DataFlow::Node getAParse();

  /**
   * Gets the root term of the regular expression parsed from this pattern.
   */
  abstract RegExpTerm getRegExpTerm();
}

/**
 * A regular expression literal, viewed as the pattern source for itself.
 */
private class RegExpLiteralPatternSource extends RegExpPatternSource {
  private Ast::RegExpLiteral astNode;

  RegExpLiteralPatternSource() { astNode = this.asExpr().getExpr() }

  override DataFlow::Node getAParse() { result = this }

  override RegExpTerm getRegExpTerm() { result = astNode.getParsed() }
}

/**
 * A node whose string value may flow to a position where it is interpreted
 * as a part of a regular expression.
 */
private class StringRegExpPatternSource extends RegExpPatternSource {
  private DataFlow::Node parse;

  StringRegExpPatternSource() { this = regExpSource(parse) }

  override DataFlow::Node getAParse() { result = parse }

  override RegExpTerm getRegExpTerm() { result.getRegExp() = this.asExpr().getExpr() }
}

private class RegExpLiteralRegExp extends RegExp, Ast::RegExpLiteral {
  override predicate isDotAll() { this.hasMultilineFlag() }

  override predicate isIgnoreCase() { this.hasCaseInsensitiveFlag() }

  override string getFlags() { result = this.getFlagString() }
}

private class ParsedStringRegExp extends RegExp {
  private DataFlow::Node parse;

  ParsedStringRegExp() { this = regExpSource(parse).asExpr().getExpr() }

  DataFlow::Node getAParse() { result = parse }

  override predicate isDotAll() { none() }

  override predicate isIgnoreCase() { none() }

  override string getFlags() { none() }
}

/** Provides a class for modeling regular expression interpretations. */
module RegExpInterpretation {
  /**
   * A node that is not a regular expression literal, but is used in places that
   * may interpret it as one. Instances of this class are typically strings that
   * flow to method calls like `RegExp.new`.
   */
  abstract class Range extends DataFlow::Node { }
}

/**
 * A node interpreted as a regular expression.
 */
class StdLibRegExpInterpretation extends RegExpInterpretation::Range {
  StdLibRegExpInterpretation() {
    // The first argument to an invocation of `Regexp.new` or `Regexp.compile`.
    this = API::getTopLevelMember("Regexp").getAMethodCall(["compile", "new"]).getArgument(0)
    or
    // The argument of a call that coerces the argument to a regular expression.
    exists(DataFlow::CallNode mce |
      mce.getMethodName() = ["match", "match?"] and
      this = mce.getArgument(0) and
      // exclude https://ruby-doc.org/core-2.4.0/Regexp.html#method-i-match
      not mce.getReceiver() = trackRegexpType()
    )
  }
}

/**
 * Gets a node whose value may flow (inter-procedurally) to `re`, where it is interpreted
 * as a part of a regular expression.
 */
cached
DataFlow::Node regExpSource(DataFlow::Node re) {
  exists(RegExpConfiguration c | c.hasFlow(result, re))
}
