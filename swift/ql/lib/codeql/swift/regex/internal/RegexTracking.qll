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
 * A data flow configuration for tracking string literals that are used to
 * create regular expression objects, or are evaluated directly as regular
 * expressions.
 */
private module StringLiteralUseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof StringLiteralExpr }

  predicate isSink(DataFlow::Node node) {
    // evaluated directly as a regular expression
    node.asExpr() = any(RegexEval eval).getRegexInput()
    or
    // used to create a regular expression object
    node = any(RegexCreation regexCreation).getStringInput()
  }
}

module StringLiteralUseFlow = DataFlow::Global<StringLiteralUseConfig>;

/**
 * A data flow configuration for tracking regular expression objects from
 * creation to the point of use.
 */
private module RegexUseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    // creation of the regex
    node instanceof RegexCreation
    // TODO: track parse mode flags.
  }

  predicate isSink(DataFlow::Node node) {
    // evaluation of the regex
    node.asExpr() = any(RegexEval eval).getRegexInput()
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // TODO: flow through regex methods that return a modified regex.
    none()
  }
}

module RegexUseFlow = DataFlow::Global<RegexUseConfig>;
