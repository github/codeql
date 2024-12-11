/**
 * Contains a class with flow states that are used by multiple queries.
 */

private import javascript
private import TaintedUrlSuffixCustomizations

private newtype TFlowState =
  TTaint() or
  TTaintedUrlSuffix() or

/**
 * A flow state indicating which part of a value is tainted.
 */
class FlowState extends TFlowState {
  /**
   * Holds if this represents a value that is considered entirely tainted, except the first character
   * might not be user-controlled.
   */
  predicate isTaint() { this = TTaint() }

  /**
   * Holds if this represents a URL whose fragment and/or query parts are considered tainted.
   */
  predicate isTaintedUrlSuffix() { this = TTaintedUrlSuffix() }

  /** Gets a string representation of this flow state. */
  string toString() {
    this.isTaint() and result = "taint"
    or
    this.isTaintedUrlSuffix() and result = "tainted-url-suffix"
    or
    this.isTaintedPrefix() and result = "tainted-prefix"
  }

  /** DEPRECATED. Gets the corresponding flow label. */
  deprecated DataFlow::FlowLabel toFlowLabel() {
    this.isTaint() and result.isTaint()
    or
    this.isTaintedUrlSuffix() and result = TaintedUrlSuffix::label()
    or
    this.isTaintedPrefix() and result = "PrefixString"
  }
}

/** Convenience predicates for working with common flow states. */
module FlowState {
  /**
   * Gets the flow state representing a value that is considered entirely tainted, except the first character
   * might not be user-controlled.
   */
  FlowState taint() { result.isTaint() }

  /**
   * Gets the flow state representing a URL whose fragment and/or query parts are considered tainted.
   */
  FlowState taintedUrlSuffix() { result.isTaintedUrlSuffix() }

  /** DEPRECATED. Gets the flow state corresponding to `label`. */
  deprecated FlowState fromFlowLabel(DataFlow::FlowLabel label) { result.toFlowLabel() = label }
}
