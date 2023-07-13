/**
 * Provides classes and predicates that track strings and regular expressions
 * to where they are used, along with properties of the regex such as parse
 * mode flags that have been set.
 */

import swift
import codeql.swift.regex.RegexTreeView
private import codeql.swift.dataflow.DataFlow
private import ParseRegex
private import codeql.swift.regex.Regex

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

module RegexUseFlow = DataFlow::Global<RegexUseConfig>;
