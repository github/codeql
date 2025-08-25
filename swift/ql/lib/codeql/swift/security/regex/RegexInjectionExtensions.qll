/**
 * Provides classes and predicates to reason about regular expression injection
 * vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow
import codeql.swift.regex.Regex

/**
 * A data flow sink for regular expression injection vulnerabilities.
 */
abstract class RegexInjectionSink extends DataFlow::Node { }

/**
 * A barrier for regular expression injection vulnerabilities.
 */
abstract class RegexInjectionBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class RegexInjectionAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to regular expression injection vulnerabilities.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/**
 * A sink that is a regular expression evaluation defined in the Regex library.
 * This includes various methods that consume a regular expression string, but
 * in general misses cases where a regular expression string is converted into
 * an object (such as a `Regex` or `NSRegularExpression`) for later evaluation.
 * These cases are modeled separately.
 */
private class EvalRegexInjectionSink extends RegexInjectionSink {
  EvalRegexInjectionSink() { this = any(RegexEval e).getRegexInputNode() }
}

/**
 * A sink that is a regular expression use defined in a CSV model.
 */
private class DefaultRegexInjectionSink extends RegexInjectionSink {
  DefaultRegexInjectionSink() { sinkNode(this, "regex-use") }
}

private class RegexInjectionSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";Regex;true;init(_:);;;Argument[0];regex-use",
        ";Regex;true;init(_:as:);;;Argument[0];regex-use",
        ";NSRegularExpression;true;init(pattern:options:);;;Argument[0];regex-use",
      ]
  }
}

/**
 * A barrier for regular expression injection vulnerabilities.
 */
private class RegexInjectionDefaultBarrier extends RegexInjectionBarrier {
  RegexInjectionDefaultBarrier() {
    // any numeric type
    this.asExpr().getType().getUnderlyingType().getABaseType*().getName() =
      ["Numeric", "SignedInteger", "UnsignedInteger"]
  }
}
