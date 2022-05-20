/**
 * Provides default sources, sinks and sanitizers for detecting
 * "reflected server-side cross-site scripting"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "reflected server-side cross-site scripting"
 * vulnerabilities, as well as extension points for adding your own.
 */
module ReflectedXss {
  /**
   * A data flow source for "reflected server-side cross-site scripting" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "reflected server-side cross-site scripting" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "reflected server-side cross-site scripting" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for "reflected server-side cross-site scripting" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * The body of a HTTP response that will be returned from a server, considered as a flow sink.
   */
  class ServerHttpResponseBodyAsSink extends Sink {
    ServerHttpResponseBodyAsSink() {
      exists(HTTP::Server::HttpResponse response |
        response.getMimetype().toLowerCase() = "text/html" and
        this = response.getBody()
      )
    }
  }

  /**
   * An HTML escaping, considered as a sanitizer.
   */
  class HtmlEscapingAsSanitizer extends Sanitizer {
    HtmlEscapingAsSanitizer() {
      // TODO: For now, since there is not an `isSanitizingStep` member-predicate part of a
      // `TaintTracking::Configuration`, we treat the output as a taint-sanitizer. This
      // is slightly imprecise, which you can see in the `m_unsafe + SAFE` test-case in
      // python/ql/test/library-tests/frameworks/markupsafe/taint_test.py
      //
      // However, it is better than `getAnInput()`. Due to use-use flow, that would remove
      // the taint-flow to `SINK()` in `some_escape(tainted); SINK(tainted)`.
      this = any(HtmlEscaping esc).getOutput()
    }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends SanitizerGuard, StringConstCompare { }
}

/** DEPRECATED: Alias for ReflectedXss */
deprecated module ReflectedXSS = ReflectedXss;
