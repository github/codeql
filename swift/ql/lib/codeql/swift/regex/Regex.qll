/**
 * Provides classes and predicates for reasoning about regular expressions.
 */

import swift
import codeql.swift.regex.RegexTreeView
private import codeql.swift.dataflow.DataFlow
private import internal.ParseRegex
private import internal.RegexTracking

/**
 * A string literal that is used as a regular expression in a regular
 * expression evaluation. For example the string literal `"(a|b).*"` in:
 * ```
 * Regex("(a|b).*").firstMatch(in: myString)
 * ```
 */
private class ParsedStringRegex extends RegExp, StringLiteralExpr {
  RegexEval eval;

  ParsedStringRegex() {
    StringLiteralUseFlow::flow(DataFlow::exprNode(this), DataFlow::exprNode(eval.getRegexInput()))
  }

  /**
   * Gets a call that evaluates this regular expression.
   */
  RegexEval getEval() { result = eval }
}

/**
 * A call that evaluates a regular expression. For example, the call to `firstMatch` in:
 * ```
 * Regex("(a|b).*").firstMatch(in: myString)
 * ```
 */
abstract class RegexEval extends CallExpr {
  /**
   * Gets the input to this call that is the regular expression being evaluated.
   */
  abstract Expr getRegexInput();

  /**
   * Gets the input to this call that is the string the regular expression is evaluated on.
   */
  abstract Expr getStringInput();

  /**
   * Gets a regular expression value that is evaluated here (if any can be identified).
   */
  RegExp getARegex() { result.(ParsedStringRegex).getEval() = this }
}

/**
 * A call to a function that always evaluates a regular expression.
 */
private class AlwaysRegexEval extends RegexEval {
  Expr regexInput;
  Expr stringInput;

  AlwaysRegexEval() {
    this.getStaticTarget()
        .(Method)
        .hasQualifiedName("Regex", ["firstMatch(in:)", "prefixMatch(in:)", "wholeMatch(in:)"]) and
    regexInput = this.getQualifier() and
    stringInput = this.getArgument(0).getExpr()
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
    regexInput = this.getQualifier() and
    stringInput = this.getArgument(0).getExpr()
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
    regexInput = this.getArgument(0).getExpr() and
    stringInput = this.getQualifier()
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
    regexInput = this.getArgument(0).getExpr() and
    stringInput = this.getQualifier()
  }

  override Expr getRegexInput() { result = regexInput }

  override Expr getStringInput() { result = stringInput }
}
