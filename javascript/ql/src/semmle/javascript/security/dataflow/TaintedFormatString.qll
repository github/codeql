/**
 * Provides a taint-tracking configuration for reasoning about format injections.
 */

import javascript
import semmle.javascript.security.dataflow.DOM

module TaintedFormatString {
  /**
   * A data flow source for format injections.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for format injections.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for format injections.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint-tracking configuration for format injections.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "TaintedFormatString" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }

  /** A source of remote user input, considered as a flow source for format injection. */
  class RemoteSource extends Source { RemoteSource() { this instanceof RemoteFlowSource } }

  /**
   * A format argument to a printf-like function, considered as a flow sink for format injection.
   */
  class FormatSink extends Sink {
    FormatSink() {
      exists(PrintfStyleCall printf |
        this = printf.getFormatString() and
        // exclude trivial case where there are no arguments to interpolate
        exists(printf.getFormatArgument(_))
      )
    }
  }
}
