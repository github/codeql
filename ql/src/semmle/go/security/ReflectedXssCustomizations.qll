/**
 * Provides classes and predicates used by the XSS queries.
 */

import go

/**
 * Provides extension points for customizing the taint-tracking configuration for reasoning about
 * reflected cross-site scripting vulnerabilities.
 */
module ReflectedXss {
  /** A data flow source for reflected XSS vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for reflected XSS vulnerabilities. */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the kind of vulnerability to report in the alert message.
     *
     * Defaults to `Cross-site scripting`, but may be overriden for sinks
     * that do not allow script injection, but injection of other undesirable HTML elements.
     */
    string getVulnerabilityKind() { result = "Cross-site scripting" }
  }

  /** A sanitizer for reflected XSS vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for reflected XSS vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * An expression that is sent as part of an HTTP response body, considered as an
   * XSS sink.
   *
   * We exclude cases where the route handler sets either an unknown content type or
   * a content type that does not (case-insensitively) contain the string "html". This
   * is to prevent us from flagging plain-text or JSON responses as vulnerable.
   */
  class HttpResponseBodySink extends Sink, HTTP::ResponseBody {
    HttpResponseBodySink() { not nonHtmlContentType(this) }
  }

  /**
   * Holds if `body` specifies the response's content type to be HTML.
   */
  private predicate htmlTypeSpecified(HTTP::ResponseBody body) {
    exists(HTTP::HeaderWrite hw, string tp | hw = body.getResponseWriter().getAHeaderWrite() |
      hw.definesHeader("content-type", tp) and tp.regexpMatch("(?i).*html.*")
    )
  }

  /**
   * Holds if `body` may send a response with a content type other than HTML.
   */
  private predicate nonHtmlContentType(HTTP::ResponseBody body) {
    not htmlTypeSpecified(body) and
    (
      exists(HTTP::HeaderWrite hw | hw = body.getResponseWriter().getAHeaderWrite() |
        hw.definesHeader("content-type", _)
      )
      or
      exists(DataFlow::CallNode call | call.getTarget().hasQualifiedName("fmt", "Fprintf") |
        body = call.getAnArgument() and
        // checks that the format value does not start with:
        //  - '<', which could lead to an HTML content type being detected, or
        //  - '%', which could be a format string.
        call.getArgument(1).getStringValue().regexpMatch("^[^<%].*")
      )
    )
  }

  /**
   * A third-party controllable input, considered as a flow source for reflected XSS.
   */
  class UntrustedFlowAsSource extends Source, UntrustedFlowSource { }

  /**
   * A regexp replacement involving an HTML meta-character, or a call to an escape
   * function, viewed as a sanitizer for XSS vulnerabilities.
   *
   * The XSS queries do not attempt to reason about correctness or completeness of sanitizers,
   * so any such call stops taint propagation.
   */
  class MetacharEscapeSanitizer extends Sanitizer, DataFlow::CallNode {
    MetacharEscapeSanitizer() {
      exists(Function f | f = this.getCall().getTarget() |
        f.(RegexpReplaceFunction).getRegexp(this).getPattern().regexpMatch(".*['\"&<>].*")
        or
        f instanceof HtmlEscapeFunction
        or
        f instanceof JsEscapeFunction
      )
    }
  }
}
