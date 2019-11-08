/**
 * Provides classes and predicates used by the XSS queries.
 */

import go

/** Provides classes and predicates for the reflected XSS query. */
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
    HttpResponseBodySink() { not nonHtmlContentType(this.getResponseWriter()) }
  }

  /**
   * Holds if `h` may send a response with a content type other than HTML.
   */
  private predicate nonHtmlContentType(HTTP::ResponseWriter rw) {
    exists(HTTP::HeaderWrite hw |
      hw = rw.getAHeaderWrite() and hw.definesHeader("content-type", _)
    |
      not exists(string tp | hw.definesHeader("content-type", tp) | tp.regexpMatch("(?i).*html.*"))
    )
  }

  /**
   * An expression that is sent as part of an HTTP header, considered as an XSS sink.
   */
  class HttpResponseHeaderSink extends Sink, HTTP::Header { }

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
