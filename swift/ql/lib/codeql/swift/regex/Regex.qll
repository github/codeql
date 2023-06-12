/**
 * Provides classes and predicates for reasoning about regular expressions.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.regex.RegexTreeView // re-export
private import internal.ParseRegex

/**
 * A data flow configuration for tracking string literals that are used as
 * regular expressions.
 */
private module RegexUseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof StringLiteralExpr }

  predicate isSink(DataFlow::Node node) { node.asExpr() = any(RegexEval eval).getRegexInput() }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // flow through `Regex` initializer, i.e. from a string to a `Regex` object.
    exists(CallExpr call |
      (
        call.getStaticTarget().(Method).hasQualifiedName("Regex", ["init(_:)", "init(_:as:)"]) or
        call.getStaticTarget()
            .(Method)
            .hasQualifiedName("NSRegularExpression", "init(pattern:options:)")
      ) and
      nodeFrom.asExpr() = call.getArgument(0).getExpr() and
      nodeTo.asExpr() = call
    )
  }
}

private module RegexUseFlow = DataFlow::Global<RegexUseConfig>;

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
    RegexUseFlow::flow(DataFlow::exprNode(this), DataFlow::exprNode(eval.getRegexInput()))
  }

  /**
   * Gets a call that evaluates this regular expression.
   */
  RegexEval getEval() { result = eval }
}

/**
 * A call that evaluates a regular expression. For example:
 * ```
 * Regex("(a|b).*").firstMatch(in: myString)
 * ```
 */
abstract class RegexEval extends CallExpr {
  Expr regexInput;
  Expr stringInput;

  /**
   * Gets the input to this call that is the regular expression.
   */
  Expr getRegexInput() { result = regexInput }

  /**
   * Gets the input to this call that is the string the regular expression is evaluated on.
   */
  Expr getStringInput() { result = stringInput }

  /**
   * Gets a regular expression value that is evaluated here (if any can be identified).
   */
  RegExp getARegex() { exists(ParsedStringRegex regex | regex.getEval() = this and result = regex) }
}

/**
 * A call to a function that always evaluates a regular expression.
 */
private class AlwaysRegexEval extends RegexEval {
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
}
