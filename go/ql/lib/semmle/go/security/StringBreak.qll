/**
 * Provides a taint tracking configuration for reasoning about unsafe-quoting vulnerabilities.
 *
 * Note: for performance reasons, only import this file if `StringBreak::Configuration` is needed,
 * otherwise `StringBreakCustomizations` should be imported instead.
 */

import go

/**
 * Provides a taint tracking configuration for reasoning about unsafe-quoting vulnerabilities.
 */
module StringBreak {
  import StringBreakCustomizations::StringBreak

  /**
   * DEPRECATED: Use `Flow` instead.
   *
   * A taint-tracking configuration for reasoning about unsafe-quoting vulnerabilities,
   * parameterized with the type of quote being tracked.
   */
  deprecated class Configuration extends TaintTracking::Configuration {
    Quote quote;

    Configuration() { this = "StringBreak" + quote }

    /** Gets the type of quote being tracked by this configuration. */
    Quote getQuote() { result = quote }

    override predicate isSource(DataFlow::Node nd) { nd instanceof Source }

    override predicate isSink(DataFlow::Node nd) { quote = nd.(Sink).getQuote() }

    override predicate isSanitizer(DataFlow::Node nd) { quote = nd.(Sanitizer).getQuote() }
  }

  private module Config implements DataFlow::StateConfigSig {
    /** The flow state that we track is the type of quote used. */
    class FlowState = Quote;

    predicate isSource(DataFlow::Node source, FlowState state) {
      source instanceof Source and exists(state)
    }

    predicate isSink(DataFlow::Node sink, FlowState state) { state = sink.(Sink).getQuote() }

    predicate isBarrier(DataFlow::Node node, FlowState state) {
      state = node.(Sanitizer).getQuote()
    }
  }

  /**
   * Tracks taint flow from untrusted data which may contain single or double
   * quotes to uses where those quotes need to be escaped. The type of quote
   * is accessible through the `Sink`.
   */
  module Flow = TaintTracking::GlobalWithState<Config>;
}
