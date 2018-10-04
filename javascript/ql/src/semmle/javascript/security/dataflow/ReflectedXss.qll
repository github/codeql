/**
 * Provides a taint-tracking configuration for reasoning about reflected
 * cross-site scripting vulnerabilities.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources
import semmle.javascript.frameworks.jQuery

module ReflectedXss {
  /**
   * A data flow source for XSS vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for XSS vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for XSS vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint-tracking configuration for reasoning about XSS.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ReflectedXss" }

    override predicate isSource(DataFlow::Node source) {
      source instanceof Source
    }

    override predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }

  /** A third-party controllable request input, considered as a flow source for reflected XSS. */
  class ThirdPartyRequestInputAccessAsSource extends Source {
    ThirdPartyRequestInputAccessAsSource() {
      this.(HTTP::RequestInputAccess).isThirdPartyControllable()
      or
      this.(HTTP::RequestHeaderAccess).getAHeaderName() = "referer"
    }
  }

  /**
   * An expression that is sent as part of an HTTP response, considered as an XSS sink.
   *
   * We exclude cases where the route handler sets either an unknown content type or
   * a content type that does not (case-insensitively) contain the string "html". This
   * is to prevent us from flagging plain-text or JSON responses as vulnerable.
   */
  private class HttpResponseSink extends Sink {
    HttpResponseSink() {
      exists (HTTP::ResponseSendArgument sendarg | sendarg = asExpr() |
        forall (HTTP::HeaderDefinition hd |
          hd = sendarg.getRouteHandler().getAResponseHeader("content-type") |
          exists (string tp | hd.defines("content-type", tp) |
            tp.toLowerCase().matches("%html%")
          )
        )
      )
    }
  }
}

/** DEPRECATED: Use `ReflectedXss::Source` instead. */
deprecated class XssSource = ReflectedXss::Source;

/** DEPRECATED: Use `ReflectedXss::Sink` instead. */
deprecated class XssSink = ReflectedXss::Sink;

/** DEPRECATED: Use `ReflectedXss::Sanitizer` instead. */
deprecated class XssSanitizer = ReflectedXss::Sanitizer;

/** DEPRECATED: Use `ReflectedXss::Configuration` instead. */
deprecated class XssDataFlowConfiguration = ReflectedXss::Configuration;
