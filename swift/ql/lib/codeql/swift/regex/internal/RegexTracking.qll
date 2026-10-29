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
    node = any(RegexEval eval).getRegexInputNode()
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
    node = any(RegexEval eval).getRegexInputNode()
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(RegexAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

module RegexUseFlow = DataFlow::Global<RegexUseConfig>;

/**
 * A data flow configuration for tracking regular expression parse mode
 * flags from wherever they are created or set through to regular expression
 * evaluation. The flow state encodes which parse mode flag was set.
 */
private module RegexParseModeConfig implements DataFlow::StateConfigSig {
  class FlowState = RegexParseMode;

  predicate isSource(DataFlow::Node node, FlowState flowstate) {
    // parse mode flag is set
    any(RegexAdditionalFlowStep s).setsParseMode(node, flowstate, true)
  }

  predicate isSink(DataFlow::Node node, FlowState flowstate) {
    // evaluation of a regex
    (
      node = any(RegexEval eval).getRegexInputNode() or
      node = any(RegexEval eval).getAnOptionsInput()
    ) and
    exists(flowstate)
  }

  predicate isBarrier(DataFlow::Node node) { none() }

  predicate isBarrier(DataFlow::Node node, FlowState flowstate) {
    // parse mode flag is unset
    any(RegexAdditionalFlowStep s).setsParseMode(node, flowstate, false)
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // flow through array construction
    exists(ArrayExpr arr |
      nodeFrom.asExpr() = arr.getAnElement() and
      nodeTo.asExpr() = arr
    )
    or
    // flow through regex creation
    exists(RegexCreation create |
      nodeFrom = create.getAnOptionsInput() and
      nodeTo = create
    )
    or
    // additional flow steps for regular expression objects
    any(RegexAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState flowstateFrom, DataFlow::Node nodeTo, FlowState flowStateTo
  ) {
    none()
  }
}

module RegexParseModeFlow = DataFlow::GlobalWithState<RegexParseModeConfig>;
