/**
 * Provides classes for working with regular expressions.
 *
 * Regular expression literals are represented as an abstract syntax tree of regular expression
 * terms.
 */

import regexp.RegExpTreeView // re-export
private import regexp.internal.ParseRegExp
private import codeql.ruby.ast.Literal as AST
private import codeql.ruby.DataFlow
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.internal.tainttrackingforlibraries.TaintTrackingImpl

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
  private AST::RegExpLiteral astNode;

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

private class RegExpLiteralRegExp extends RegExp, AST::RegExpLiteral {
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

/**
 * Holds if `source` may be interpreted as a regular expression.
 */
private predicate isInterpretedAsRegExp(DataFlow::Node source) {
  // The first argument to an invocation of `Regexp.new` or `Regexp.compile`.
  source = API::getTopLevelMember("Regexp").getAMethodCall(["compile", "new"]).getArgument(0)
  or
  // The argument of a call that coerces the argument to a regular expression.
  exists(DataFlow::CallNode mce |
    mce.getMethodName() = ["match", "match?"] and
    source = mce.getArgument(0) and
    // exclude https://ruby-doc.org/core-2.4.0/Regexp.html#method-i-match
    not mce.getReceiver().asExpr().getExpr() instanceof AST::RegExpLiteral
  )
}

private class RegExpConfiguration extends Configuration {
  RegExpConfiguration() { this = "RegExpConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() =
      any(ExprCfgNode e |
        e.getConstantValue().isString(_) and
        not e instanceof ExprNodes::VariableReadAccessCfgNode and
        not e instanceof ExprNodes::ConstantReadAccessCfgNode
      )
  }

  override predicate isSink(DataFlow::Node sink) { isInterpretedAsRegExp(sink) }

  override predicate isSanitizer(DataFlow::Node node) {
    // stop flow if `node` is receiver of
    // https://ruby-doc.org/core-2.4.0/String.html#method-i-match
    exists(DataFlow::CallNode mce |
      mce.getMethodName() = ["match", "match?"] and
      node = mce.getReceiver() and
      mce.getArgument(0).asExpr().getExpr() instanceof AST::RegExpLiteral
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
