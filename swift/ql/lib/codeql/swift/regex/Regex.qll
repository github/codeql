/**
 * Provides classes and predicates for reasoning about regular expressions.
 */

import swift
import codeql.swift.dataflow.DataFlow

import codeql.swift.regex.RegexTreeView // re-export
private import internal.ParseRegex
//private import codeql.regex.internal.RegExpTracking as RegExpTracking

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

/* *
 * A node whose string value may flow to a position where it is interpreted
 * as a part of a regular expression.
 *
private class StringRegExpPatternSource extends RegExpPatternSource {
  private DataFlow::Node parse;

  StringRegExpPatternSource() {
    this = regExpSource(parse) and
    // `regExpSource()` tracks both strings and regex literals, narrow it down to strings.
    this.asExpr().getConstantValue().isString(_)
  }

  override DataFlow::Node getAParse() { result = parse }

  override RegExpTerm getRegExpTerm() { result.getRegExp() = this.asExpr().getExpr() }
}*/

/**
 * TODO
 * "(a|b).*"
 */
private class ParsedStringRegExp extends RegExp, StringLiteralExpr {
  private DataFlow::Node parse;

  ParsedStringRegExp() {
    //this = regExpSource(parse).asExpr().getExpr()
    parse.asExpr() = this
  }

  DataFlow::Node getAParse() { result = parse }
 /*
  override predicate isDotAll() { none() }

  override predicate isIgnoreCase() { none() }

  override string getFlags() { none() }*/
}

/**
 * A call that evaluates a regular expression. For example:
 * ```
 * Regex("(a|b).*").firstMatch(in: myString)
 * ```
 */
abstract class RegexEval extends CallExpr {
  Expr regex;
  Expr input;

  /**
   * Gets the regular expression that is evaluated.
   */
  Expr getRegex() { result = regex }

  /**
   * Gets the input string the regular expression is evaluated on.
   */
  Expr getInput() { result = input }
}

/**
 * A call to a function that always evaluates a regular expression.
 */
private class AlwaysRegexEval extends RegexEval {
  AlwaysRegexEval() {
    this.getStaticTarget()
        .(Method)
        .hasQualifiedName("Regex", ["firstMatch(in:)", "prefixMatch(in:)", "wholeMatch(in:)"]) and
    regex = this.getQualifier() and
    input = this.getArgument(0).getExpr()
    or
    this.getStaticTarget()
        .(Method)
        .hasQualifiedName("NSRegularExpression",
          [
            "numberOfMatches(in:options:range:)", "enumerateMatches(in:options:range:using:)",
            "matches(in:options:range:)", "firstMatch(in:options:range:)",
            "rangeOfFirstMatch(in:options:range:)",
            "replaceMatches(in:options:range:withTemplate:)",
            "stringByReplacingMatches(in:options:range:withTemplate:)"
          ]) and
    regex = this.getQualifier() and
    input = this.getArgument(0).getExpr()
    or
    this.getStaticTarget()
        .(Method)
        .hasQualifiedName("BidirectionalCollection",
          [
            "contains(_:)", "firstMatch(of:)", "firstRange(of:)", "matches(of:)",
            "prefixMatch(of:)", "ranges(of:)",
            "split(separator:maxSplits:omittingEmptySubsequences:)", "starts(with:)",
            "trimmingPrefix(_:)", "wholeMatch(of:)"
          ]) and
    regex = this.getArgument(0).getExpr() and
    input = this.getQualifier()
    or
    this.getStaticTarget()
        .(Method)
        .hasQualifiedName("RangeReplaceableCollection",
          [
            "replace(_:maxReplacements:with:)", "replace(_:with:maxReplacements:)",
            "replacing(_:maxReplacements:with:)", "replacing(_:subrange:maxReplacements:with:)",
            "replacing(_:with:maxReplacements:)", "replacing(_:with:subrange:maxReplacements:)",
            "trimPrefix(_:)"
          ]) and
    regex = this.getArgument(0).getExpr() and
    input = this.getQualifier()
  }
}
