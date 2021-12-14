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
   * A taint-tracking configuration for reasoning about unsafe-quoting vulnerabilities,
   * parameterized with the type of quote being tracked.
   */
  class Configuration extends TaintTracking::Configuration {
    Quote quote;

    Configuration() { this = "StringBreak" + quote }

    /** Gets the type of quote being tracked by this configuration. */
    Quote getQuote() { result = quote }

    override predicate isSource(DataFlow::Node nd) { nd instanceof Source }

    override predicate isSink(DataFlow::Node nd) { quote = nd.(Sink).getQuote() }

    override predicate isSanitizer(DataFlow::Node nd) { quote = nd.(Sanitizer).getQuote() }
  }
}
