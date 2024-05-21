/**
 * Provides classes for working with regular expressions.
 *
 * Regular expression literals are represented as an abstract syntax tree of regular expression
 * terms.
 */

import regexp.RegExpTreeView // re-export
private import regexp.internal.ParseRegExp
private import regexp.internal.RegExpTracking as RegExpTracking
private import codeql.ruby.AST as Ast
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts

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

  StringRegExpPatternSource() {
    this = regExpSource(parse) and
    // `regExpSource()` tracks both strings and regex literals, narrow it down to strings.
    this.asExpr().getConstantValue().isString(_)
  }

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
 * Speficically nodes where string values are interpreted as regular expressions.
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
      not mce.getReceiver() = RegExpTracking::trackRegexpType() and
      // exclude non-stdlib methods
      not exists(mce.getATarget())
    )
  }
}

/**
 * Holds if `exec` is a node where `regexp` is interpreted as a regular expression and
 * tested against the string value of `input`.
 * `name` describes the regexp execution, typically the name of the method being called.
 */
private predicate regexExecution(
  DataFlow::Node exec, DataFlow::Node input, DataFlow::Node regexp, string name
) {
  // `=~` or `!~`
  exists(CfgNodes::ExprNodes::BinaryOperationCfgNode op |
    name = op.getOperator() and
    exec.asExpr() = op and
    (
      op.getExpr() instanceof Ast::RegExpMatchExpr or
      op.getExpr() instanceof Ast::NoRegExpMatchExpr
    ) and
    (
      input.asExpr() = op.getLeftOperand() and regexp.asExpr() = op.getRightOperand()
      or
      input.asExpr() = op.getRightOperand() and regexp.asExpr() = op.getLeftOperand()
    )
  )
  or
  // Any of the methods on `String` that take a regexp.
  exists(DataFlow::CallNode call | exec = call |
    name = "String#" + call.getMethodName() and
    call.getMethodName() =
      [
        "[]", "gsub", "gsub!", "index", "match", "match?", "partition", "rindex", "rpartition",
        "scan", "slice!", "split", "sub", "sub!"
      ] and
    input = call.getReceiver() and
    regexp = call.getArgument(0) and
    // exclude https://ruby-doc.org/core-2.4.0/Regexp.html#method-i-match, they are handled on the next case of this disjunction
    // also see `StdLibRegExpInterpretation`
    not (
      call.getMethodName() = ["match", "match?"] and
      call.getReceiver() = RegExpTracking::trackRegexpType()
    )
  )
  or
  // A call to `match` or `match?` where the regexp is the receiver.
  exists(DataFlow::CallNode call | exec = call |
    name = "Regexp#" + call.getMethodName() and
    call.getMethodName() = ["match", "match?"] and
    regexp = call.getReceiver() and
    input = call.getArgument(0)
  )
  or
  // a case-when statement
  exists(CfgNodes::ExprNodes::CaseExprCfgNode caseExpr |
    exec.asExpr() = caseExpr and
    input.asExpr() = caseExpr.getValue()
  |
    name = "case-when" and
    regexp.asExpr() = caseExpr.getBranch(_).(CfgNodes::ExprNodes::WhenClauseCfgNode).getPattern(_)
    or
    name = "case-in" and
    regexp.asExpr() = caseExpr.getBranch(_).(CfgNodes::ExprNodes::InClauseCfgNode).getPattern()
  )
}

/**
 * An execution of a regular expression by the standard library.
 */
private class StdRegexpExecution extends RegexExecution::Range {
  DataFlow::Node regexp;
  DataFlow::Node input;
  string name;

  StdRegexpExecution() { regexExecution(this, input, regexp, name) }

  override DataFlow::Node getRegex() { result = regexp }

  override DataFlow::Node getString() { result = input }

  override string getName() { result = name }
}

/**
 * Gets a node whose value may flow (inter-procedurally) to `re`, where it is interpreted
 * as a part of a regular expression.
 */
cached
DataFlow::Node regExpSource(DataFlow::Node re) { result = RegExpTracking::regExpSource(re) }

/** Gets a parsed regular expression term that is executed at `exec`. */
RegExpTerm getTermForExecution(RegexExecution exec) {
  exists(RegExpPatternSource source | source = regExpSource(exec.getRegex()) |
    result = source.getRegExpTerm()
  )
}
