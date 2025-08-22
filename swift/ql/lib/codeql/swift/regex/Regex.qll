/**
 * Provides classes and predicates for reasoning about regular expressions.
 */

import swift
import codeql.swift.regex.RegexTreeView
private import codeql.swift.dataflow.DataFlow
private import internal.ParseRegex
private import internal.RegexTracking

/**
 * A data flow node whose value may flow to a position where it is interpreted
 * as a part of a regular expression. For example the string literal
 * `"(a|b).*"` in:
 * ```
 * Regex("(a|b).*").firstMatch(in: myString)
 * ```
 */
abstract class RegexPatternSource extends DataFlow::Node {
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
 * For each `RegexPatternSource` data flow node, the corresponding `Expr` is
 * a `Regex`. This is a simple wrapper to make that happen.
 */
private class RegexFromRegexPatternSource extends RegExp {
  RegexFromRegexPatternSource() { this = any(RegexPatternSource node).asExpr() }
}

/**
 * A string literal that is used as a regular expression. For example
 * the string literal `"(a|b).*"` in:
 * ```
 * Regex("(a|b).*").firstMatch(in: myString)
 * ```
 */
private class ParsedStringRegex extends RegexPatternSource {
  StringLiteralExpr expr;
  DataFlow::Node use;

  ParsedStringRegex() {
    expr = this.asExpr() and
    StringLiteralUseFlow::flow(this, use)
  }

  override DataFlow::Node getAParse() { result = use }

  override RegExpTerm getRegExpTerm() { result.getRegExp() = expr }
}

/**
 * A data-flow node where a regular expression object is created.
 */
abstract class RegexCreation extends DataFlow::Node {
  /**
   * Gets a dataflow node for the string that the regular expression object is
   * created from.
   */
  abstract DataFlow::Node getStringInput();

  /**
   * Gets a dataflow node for an options input that might contain options
   * such as parse mode flags (if any).
   */
  DataFlow::Node getAnOptionsInput() { none() }
}

/**
 * A data-flow node where a `Regex` object is created.
 */
private class RegexRegexCreation extends RegexCreation {
  DataFlow::Node input;

  RegexRegexCreation() {
    exists(CallExpr call |
      call.getStaticTarget().(Method).hasQualifiedName("Regex", ["init(_:)", "init(_:as:)"]) and
      input.asExpr() = call.getArgument(0).getExpr() and
      this.asExpr() = call
    )
  }

  override DataFlow::Node getStringInput() { result = input }
}

/**
 * A data-flow node where an `NSRegularExpression` object is created.
 */
private class NSRegularExpressionRegexCreation extends RegexCreation {
  DataFlow::Node input;

  NSRegularExpressionRegexCreation() {
    exists(CallExpr call |
      call.getStaticTarget()
          .(Method)
          .hasQualifiedName("NSRegularExpression", "init(pattern:options:)") and
      input.asExpr() = call.getArgument(0).getExpr() and
      this.asExpr() = call
    )
  }

  override DataFlow::Node getStringInput() { result = input }

  override DataFlow::Node getAnOptionsInput() {
    result.asExpr() = this.asExpr().(CallExpr).getArgument(1).getExpr()
  }
}

private newtype TRegexParseMode =
  MkIgnoreCase() or // case insensitive
  MkVerbose() or // ignores whitespace and `#` comments within patterns
  MkDotAll() or // dot matches all characters, including line terminators
  MkMultiLine() or // `^` and `$` also match beginning and end of lines
  MkUnicodeBoundary() or // Unicode UAX 29 word boundary mode
  MkUnicode() or // Unicode matching
  MkAnchoredStart() // match must begin at start of string

/**
 * A regular expression parse mode flag.
 */
class RegexParseMode extends TRegexParseMode {
  /**
   * Gets the name of this parse mode flag.
   */
  string getName() {
    this = MkIgnoreCase() and result = "IGNORECASE"
    or
    this = MkVerbose() and result = "VERBOSE"
    or
    this = MkDotAll() and result = "DOTALL"
    or
    this = MkMultiLine() and result = "MULTILINE"
    or
    this = MkUnicodeBoundary() and result = "UNICODEBOUNDARY"
    or
    this = MkUnicode() and result = "UNICODE"
    or
    this = MkAnchoredStart() and result = "ANCHOREDSTART"
  }

  /**
   * Gets a textual representation of this `RegexParseMode`.
   */
  string toString() { result = this.getName() }
}

/**
 * A unit class for adding additional flow steps for regular expressions.
 */
class RegexAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for regular expressions.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);

  /**
   * Holds if a regular expression parse mode is either set (`isSet` = true)
   * or unset (`isSet` = false) at `node`. Parse modes propagate through
   * array construction and regex construction.
   */
  abstract predicate setsParseMode(DataFlow::Node node, RegexParseMode mode, boolean isSet);
}

/**
 * An additional flow step for `Regex`.
 */
class RegexRegexAdditionalFlowStep extends RegexAdditionalFlowStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    this.setsParseModeEdge(nodeFrom, nodeTo, _, _)
  }

  override predicate setsParseMode(DataFlow::Node node, RegexParseMode mode, boolean isSet) {
    this.setsParseModeEdge(_, node, mode, isSet)
  }

  private predicate setsParseModeEdge(
    DataFlow::Node nodeFrom, DataFlow::Node nodeTo, RegexParseMode mode, boolean isSet
  ) {
    // `Regex` methods that modify the parse mode of an existing `Regex` object.
    exists(CallExpr ce |
      nodeFrom.asExpr() = ce.getQualifier() and
      nodeTo.asExpr() = ce and
      // decode the parse mode being set
      (
        ce.getStaticTarget().(Method).hasQualifiedName("Regex", "ignoresCase(_:)") and
        mode = MkIgnoreCase()
        or
        ce.getStaticTarget().(Method).hasQualifiedName("Regex", "dotMatchesNewlines(_:)") and
        mode = MkDotAll()
        or
        ce.getStaticTarget().(Method).hasQualifiedName("Regex", "anchorsMatchLineEndings(_:)") and
        mode = MkMultiLine()
      ) and
      // decode the value being set
      if ce.getArgument(0).getExpr().(BooleanLiteralExpr).getValue() = false
      then isSet = false // mode is set to false
      else isSet = true // mode is set to true OR mode is set to default (=true) OR mode is set to an unknown value
    )
  }
}

/**
 * An additional flow step for `NSRegularExpression.Options`.
 */
private class NSRegularExpressionRegexAdditionalFlowStep extends RegexAdditionalFlowStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) { none() }

  override predicate setsParseMode(DataFlow::Node node, RegexParseMode mode, boolean isSet) {
    // `NSRegularExpression.Options` values (these are typically combined, then passed into
    // the `NSRegularExpression` initializer).
    node.asExpr()
        .(MemberRefExpr)
        .getMember()
        .(FieldDecl)
        .hasQualifiedName("NSRegularExpression.Options", "caseInsensitive") and
    mode = MkIgnoreCase() and
    isSet = true
    or
    node.asExpr()
        .(MemberRefExpr)
        .getMember()
        .(FieldDecl)
        .hasQualifiedName("NSRegularExpression.Options", "allowCommentsAndWhitespace") and
    mode = MkVerbose() and
    isSet = true
    or
    node.asExpr()
        .(MemberRefExpr)
        .getMember()
        .(FieldDecl)
        .hasQualifiedName("NSRegularExpression.Options", "dotMatchesLineSeparators") and
    mode = MkDotAll() and
    isSet = true
    or
    node.asExpr()
        .(MemberRefExpr)
        .getMember()
        .(FieldDecl)
        .hasQualifiedName("NSRegularExpression.Options", "anchorsMatchLines") and
    mode = MkMultiLine() and
    isSet = true
    or
    node.asExpr()
        .(MemberRefExpr)
        .getMember()
        .(FieldDecl)
        .hasQualifiedName("NSRegularExpression.Options", "useUnicodeWordBoundaries") and
    mode = MkUnicodeBoundary() and
    isSet = true
  }
}

/**
 * An additional flow step for `NSString.CompareOptions`.
 */
private class NSStringRegexAdditionalFlowStep extends RegexAdditionalFlowStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) { none() }

  override predicate setsParseMode(DataFlow::Node node, RegexParseMode mode, boolean isSet) {
    // `NSString.CompareOptions` values (these are typically combined with
    // `NSString.CompareOptions.regularExpression`, then passed into a `StringProtocol`
    // or `NSString` method).
    node.asExpr()
        .(MemberRefExpr)
        .getMember()
        .(FieldDecl)
        .hasQualifiedName("NSString.CompareOptions", "caseInsensitive") and
    mode = MkIgnoreCase() and
    isSet = true
    or
    node.asExpr()
        .(MemberRefExpr)
        .getMember()
        .(FieldDecl)
        .hasQualifiedName("NSString.CompareOptions", "anchored") and
    mode = MkAnchoredStart() and
    isSet = true
  }
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
   * This may be a regular expression object or a string literal.
   *
   * Consider using `getARegex()` instead (which tracks the regular expression
   * input back to its source).
   */
  abstract DataFlow::Node getRegexInputNode();

  /**
   * Gets the input to this call that is the string the regular expression is evaluated on.
   */
  abstract DataFlow::Node getStringInputNode();

  /**
   * Gets a dataflow node for an options input that might contain options such
   * as parse mode flags (if any).
   */
  DataFlow::Node getAnOptionsInput() { none() }

  /**
   * Holds if this regular expression evaluation is a 'replacement' operation,
   * such as replacing all matches of the regular expression in the input
   * string with another string.
   */
  abstract predicate isUsedAsReplace();

  /**
   * Gets a regular expression value that is evaluated here (if any can be identified).
   */
  RegExp getARegex() {
    // string literal used directly as a regex
    DataFlow::exprNode(result).(ParsedStringRegex).getAParse() = this.getRegexInputNode()
    or
    // string literal -> regex object -> use
    exists(RegexCreation regexCreation |
      DataFlow::exprNode(result).(ParsedStringRegex).getAParse() = regexCreation.getStringInput() and
      RegexUseFlow::flow(regexCreation, this.getRegexInputNode())
    )
  }

  /**
   * Gets a parse mode that is set at this evaluation (in at least one path
   * from the creation of the regular expression object).
   */
  RegexParseMode getAParseMode() {
    exists(DataFlow::Node setNode |
      // parse mode flag is set
      any(RegexAdditionalFlowStep s).setsParseMode(setNode, result, true) and
      // reaches this eval
      (
        RegexParseModeFlow::flow(setNode, this.getRegexInputNode()) or
        RegexParseModeFlow::flow(setNode, this.getAnOptionsInput())
      )
    )
  }
}

/**
 * A call to a function that always evaluates a regular expression.
 */
private class AlwaysRegexEval extends RegexEval {
  DataFlow::Node regexInput;
  DataFlow::Node stringInput;

  AlwaysRegexEval() {
    this.getStaticTarget()
        .(Method)
        .hasQualifiedName("Regex", ["firstMatch(in:)", "prefixMatch(in:)", "wholeMatch(in:)"]) and
    regexInput.asExpr() = this.getQualifier() and
    stringInput.asExpr() = this.getArgument(0).getExpr()
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
    regexInput.asExpr() = this.getQualifier() and
    stringInput.asExpr() = this.getArgument(0).getExpr()
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
    regexInput.asExpr() = this.getArgument(0).getExpr() and
    stringInput.asExpr() = this.getQualifier()
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
    regexInput.asExpr() = this.getArgument(0).getExpr() and
    stringInput.asExpr() = this.getQualifier()
  }

  override DataFlow::Node getRegexInputNode() { result = regexInput }

  override DataFlow::Node getStringInputNode() { result = stringInput }

  override predicate isUsedAsReplace() {
    this.getStaticTarget().getName().matches(["replac%", "stringByReplac%", "trim%"])
  }
}

/**
 * A call to a function that sometimes evaluates a regular expression, if
 * `NSString.CompareOptions.regularExpression` is set as an `options` argument.
 *
 * This is a helper class for `NSStringCompareOptionsRegexEval`.
 */
private class NSStringCompareOptionsPotentialRegexEval extends CallExpr {
  DataFlow::Node regexInput;
  DataFlow::Node stringInput;
  DataFlow::Node optionsInput;

  NSStringCompareOptionsPotentialRegexEval() {
    (
      this.getStaticTarget()
          .(Method)
          .hasQualifiedName("StringProtocol",
            ["range(of:options:range:locale:)", "replacingOccurrences(of:with:options:range:)"])
      or
      this.getStaticTarget()
          .(Method)
          .hasQualifiedName("NSString",
            [
              "range(of:options:)", "range(of:options:range:)", "range(of:options:range:locale:)",
              "replacingOccurrences(of:with:options:range:)"
            ])
    ) and
    regexInput.asExpr() = this.getArgument(0).getExpr() and
    stringInput.asExpr() = this.getQualifier() and
    optionsInput.asExpr() = this.getArgumentWithLabel("options").getExpr()
  }

  DataFlow::Node getRegexInput() { result = regexInput }

  DataFlow::Node getStringInput() { result = stringInput }

  DataFlow::Node getAnOptionsInput() { result = optionsInput }
}

/**
 * A data flow configuration for tracking `NSString.CompareOptions.regularExpression`
 * values from where they are created to the point of use.
 */
private module NSStringCompareOptionsFlagConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    // creation of a `NSString.CompareOptions.regularExpression` value
    node.asExpr()
        .(MemberRefExpr)
        .getMember()
        .(FieldDecl)
        .hasQualifiedName("NSString.CompareOptions", "regularExpression")
  }

  predicate isSink(DataFlow::Node node) {
    // use in a [potential] regex eval `options` argument
    any(NSStringCompareOptionsPotentialRegexEval potentialEval).getAnOptionsInput() = node
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    // flow out from collection content at the sink.
    isSink(node) and
    c.getAReadContent() instanceof DataFlow::Content::CollectionContent
  }
}

module NSStringCompareOptionsFlagFlow = DataFlow::Global<NSStringCompareOptionsFlagConfig>;

/**
 * A call to a function that evaluates a regular expression because
 * `NSString.CompareOptions.regularExpression` is set as an `options` argument.
 */
private class NSStringCompareOptionsRegexEval extends RegexEval instanceof NSStringCompareOptionsPotentialRegexEval
{
  NSStringCompareOptionsRegexEval() {
    // check there is flow from a `NSString.CompareOptions.regularExpression` value to an `options` argument;
    // if there isn't, the input won't be interpretted as a regular expression.
    NSStringCompareOptionsFlagFlow::flow(_,
      this.(NSStringCompareOptionsPotentialRegexEval).getAnOptionsInput())
  }

  override DataFlow::Node getRegexInputNode() {
    result = this.(NSStringCompareOptionsPotentialRegexEval).getRegexInput()
  }

  override DataFlow::Node getStringInputNode() {
    result = this.(NSStringCompareOptionsPotentialRegexEval).getStringInput()
  }

  override DataFlow::Node getAnOptionsInput() {
    result = this.(NSStringCompareOptionsPotentialRegexEval).getAnOptionsInput()
  }

  override predicate isUsedAsReplace() { this.getStaticTarget().getName().matches("replac%") }
}
