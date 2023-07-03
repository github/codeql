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
 */
private class EvalRegexInjectionSink extends RegexInjectionSink {
  EvalRegexInjectionSink() { this.asExpr() = any(RegexEval e).getRegexInput() }
}

/**
 * A sink that is a regular expression use defined in a CSV model.
 */
private class DefaultRegexInjectionSink extends RegexInjectionSink {
  DefaultRegexInjectionSink() { sinkNode(this, "regex-use") }
}
