/**
 * Provides default sources, sinks and sanitizers for detecting
 * "URL redirection"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "URL redirection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module UrlRedirect {
  /**
   * A data flow source for "URL redirection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "URL redirection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "URL redirection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for "URL redirection" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A HTTP redirect response, considered as a flow sink.
   */
  class RedirectLocationAsSink extends Sink {
    RedirectLocationAsSink() {
      this = any(HTTP::Server::HttpRedirectResponse e).getRedirectLocation()
    }
  }

  /**
   * The right side of a string-concat, considered as a sanitizer.
   */
  class StringConcatAsSanitizer extends Sanitizer {
    StringConcatAsSanitizer() {
      // Url redirection is a problem only if the user controls the prefix of the URL.
      // TODO: This is a copy of the taint-sanitizer from the old points-to query, which doesn't
      // cover formatting.
      exists(BinaryExprNode string_concat | string_concat.getOp() instanceof Add |
        string_concat.getRight() = this.asCfgNode()
      )
    }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends SanitizerGuard, StringConstCompare { }
}
