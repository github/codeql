/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * format injections, as well as extension points for adding your own.
 */

/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * format injections, as well as extension points for adding your own.
 */
module TaintedFormatString {
  import TaintedFormatStringSpecific

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

  /** A source of remote user input, considered as a flow source for format injection. */
  class RemoteSource extends Source instanceof RemoteFlowSource { }

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
