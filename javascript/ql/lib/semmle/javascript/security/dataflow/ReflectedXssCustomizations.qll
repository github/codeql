/**
 * Provides default sources for reasoning about reflected
 * cross-site scripting vulnerabilities.
 */

import javascript

module ReflectedXss {
  private import Xss::Shared as Shared

  /** A data flow source for reflected XSS vulnerabilities. */
  abstract class Source extends Shared::Source { }

  /** A data flow sink for reflected XSS vulnerabilities. */
  abstract class Sink extends Shared::Sink { }

  /** A sanitizer for reflected XSS vulnerabilities. */
  abstract class Sanitizer extends Shared::Sanitizer { }

  /**
   * An expression that is sent as part of an HTTP response, considered as an XSS sink.
   *
   * We exclude cases where the route handler sets either an unknown content type or
   * a content type that does not (case-insensitively) contain the string "html". This
   * is to prevent us from flagging plain-text or JSON responses as vulnerable.
   */
  class HttpResponseSink extends Sink instanceof Http::ResponseSendArgument {
    HttpResponseSink() { not exists(getAXssSafeHeaderDefinition(this)) }
  }

  /**
   * Gets a HeaderDefinition that defines a XSS safe content-type for `send`.
   */
  Http::HeaderDefinition getAXssSafeHeaderDefinition(Http::ResponseSendArgument send) {
    exists(Http::RouteHandler h |
      send.getRouteHandler() = h and
      result = xssSafeContentTypeHeader(h)
    |
      // The HeaderDefinition affects a response sent at `send`.
      headerAffects(result, send)
    )
  }

  /**
   * Gets a content-type that may lead to javascript code being executed in the browser.
   * ref: https://portswigger.net/web-security/cross-site-scripting/cheat-sheet#content-types
   */
  string xssUnsafeContentType() {
    result =
      [
        "text/html", "application/xhtml+xml", "application/xml", "text/xml", "image/svg+xml",
        "text/xsl", "application/vnd.wap.xhtml+xml", "text/rdf", "application/rdf+xml",
        "application/mathml+xml", "text/vtt", "text/cache-manifest"
      ]
  }

  /**
   * Holds if `h` may send a response with a content type that is safe for XSS.
   */
  Http::HeaderDefinition xssSafeContentTypeHeader(Http::RouteHandler h) {
    result = h.getAResponseHeader("content-type") and
    not exists(string tp | result.defines("content-type", tp) |
      tp.toLowerCase().matches(xssUnsafeContentType() + "%")
    )
  }

  /**
   * Holds if a header set in `header` is likely to affect a response sent at `sender`.
   */
  predicate headerAffects(Http::HeaderDefinition header, Http::ResponseSendArgument sender) {
    sender.getRouteHandler() = header.getRouteHandler() and
    (
      // `sender` is affected by a dominating `header`.
      header.getBasicBlock().(ReachableBasicBlock).dominates(sender.getBasicBlock())
      or
      // There is no dominating header, and `header` is non-local.
      not isLocalHeaderDefinition(header) and
      not exists(Http::HeaderDefinition dominatingHeader |
        dominatingHeader.getAHeaderName() = "content-type" and
        dominatingHeader.getBasicBlock().(ReachableBasicBlock).dominates(sender.getBasicBlock())
      )
    )
  }

  bindingset[headerBlock]
  pragma[inline_late]
  private predicate doesNotDominateCallback(ReachableBasicBlock headerBlock) {
    not exists(Expr e | e instanceof Function | headerBlock.dominates(e.getBasicBlock()))
  }

  /**
   * Holds if the HeaderDefinition `header` seems to be local.
   * A HeaderDefinition is local if it dominates exactly one `ResponseSendArgument`.
   *
   * Recognizes variants of:
   * ```
   * response.writeHead(500, ...);
   * response.end('Some error');
   * return;
   * ```
   */
  predicate isLocalHeaderDefinition(Http::HeaderDefinition header) {
    exists(ReachableBasicBlock headerBlock | headerBlock = header.getBasicBlock() |
      1 =
        strictcount(Http::ResponseSendArgument sender |
          sender.getRouteHandler() = header.getRouteHandler() and
          header.getBasicBlock().(ReachableBasicBlock).dominates(sender.getBasicBlock())
        ) and
      // doesn't dominate something that looks like a callback.
      doesNotDominateCallback(headerBlock)
    )
  }

  /**
   * A regexp replacement involving an HTML meta-character, viewed as a sanitizer for
   * XSS vulnerabilities.
   *
   * The XSS queries do not attempt to reason about correctness or completeness of sanitizers,
   * so any such replacement stops taint propagation.
   */
  private class MetacharEscapeSanitizer extends Sanitizer, Shared::MetacharEscapeSanitizer { }

  private class UriEncodingSanitizer extends Sanitizer, Shared::UriEncodingSanitizer { }

  private class SerializeJavascriptSanitizer extends Sanitizer, Shared::SerializeJavascriptSanitizer
  { }

  private class IsEscapedInSwitchSanitizer extends Sanitizer, Shared::IsEscapedInSwitchSanitizer { }

  /** A third-party controllable request input, considered as a flow source for reflected XSS. */
  class ThirdPartyRequestInputAccessAsSource extends Source {
    ThirdPartyRequestInputAccessAsSource() {
      this.(Http::RequestInputAccess).isThirdPartyControllable()
      or
      this.(Http::RequestHeaderAccess).getAHeaderName() = "referer"
    }
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() { this = ModelOutput::getASinkNode("html-injection").asSink() }
  }
}
