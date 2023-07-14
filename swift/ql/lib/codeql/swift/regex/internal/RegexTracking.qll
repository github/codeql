/**
 * Provides classes and predicates that track strings and regular expressions
 * to where they are used, along with properties of the regex such as parse
 * mode flags that have been set.
 */

import swift
import codeql.swift.regex.RegexTreeView
import codeql.swift.dataflow.DataFlow
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
  }

  predicate isSink(DataFlow::Node node) {
    // evaluation of the regex
    node.asExpr() = any(RegexEval eval).getRegexInput()
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(RegexAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

module RegexUseFlow = DataFlow::Global<RegexUseConfig>;

/**
 * A data flow configuration for tracking regular expression parse mode
 * flags from the point they are set to the point of use. The flow state
 * encodes which parse mode flag was set.
 */
private module RegexParseModeConfig implements DataFlow::StateConfigSig {
  class FlowState = RegexParseMode;

  predicate isSource(DataFlow::Node node, FlowState flowstate) {
    // parse mode flag is set
    any(RegexAdditionalFlowStep s).modifiesParseMode(_, node, flowstate, true)
  }

  predicate isSink(DataFlow::Node node, FlowState flowstate) {
    // evaluation of the regex
    node.asExpr() = any(RegexEval eval).getRegexInput() and
    flowstate = any(FlowState fs)
  }

  predicate isBarrier(DataFlow::Node node) { none() }

  predicate isBarrier(DataFlow::Node node, FlowState flowstate) {
    // parse mode flag is set or unset
    any(RegexAdditionalFlowStep s).modifiesParseMode(node, _, flowstate, _)
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(RegexAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState flowstateFrom, DataFlow::Node nodeTo, FlowState flowStateTo
  ) {
    none()
  }
}

module RegexParseModeFlow = DataFlow::GlobalWithState<RegexParseModeConfig>;
