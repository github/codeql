/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unvalidated URL redirection problems on the server side, as well as
 * extension points for adding your own.
 */

import javascript
import RemoteFlowSources
private import UrlConcatenation

module ServerSideUrlRedirect {
  /**
   * A data flow source for unvalidated URL redirect vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for unvalidated URL redirect vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for unvalidated URL redirect vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of third-party user input, considered as a flow source for URL redirects. */
  class ThirdPartyRequestInputAccessAsSource extends Source {
    ThirdPartyRequestInputAccessAsSource() {
      this.(HTTP::RequestInputAccess).isThirdPartyControllable()
    }
  }

  /**
   * An HTTP redirect, considered as a sink for `Configuration`.
   */
  class RedirectSink extends Sink, DataFlow::ValueNode {
    RedirectSink() { astNode = any(HTTP::RedirectInvocation redir).getUrlArgument() }
  }

  /**
   * A definition of the HTTP "Location" header, considered as a sink for
   * `Configuration`.
   */
  class LocationHeaderSink extends Sink, DataFlow::ValueNode {
    LocationHeaderSink() {
      any(HTTP::ExplicitHeaderDefinition def).definesExplicitly("location", astNode)
    }
  }

  /**
   * A call to a function called `isLocalUrl` or similar, which is
   * considered to sanitize a variable for purposes of URL redirection.
   */
  class LocalUrlSanitizingGuard extends TaintTracking::SanitizerGuardNode, DataFlow::CallNode {
    LocalUrlSanitizingGuard() { this.getCalleeName().regexpMatch("(?i)(is_?)?local_?url") }

    override predicate sanitizes(boolean outcome, Expr e) {
      // `isLocalUrl(e)` sanitizes `e` if it evaluates to `true`
      getAnArgument().asExpr() = e and
      outcome = true
    }
  }

  /**
   * A URL attribute for a React Native `WebView`.
   */
  class WebViewUrlSink extends Sink {
    WebViewUrlSink() {
      // `url` or `source.uri` properties of React Native `WebView`
      exists(ReactNative::WebViewElement webView, DataFlow::SourceNode source, string prop |
        source = webView and prop = "url"
        or
        source = webView.getAPropertyWrite("source").getRhs().getALocalSource() and prop = "uri"
      |
        this = source.getAPropertyWrite(prop).getRhs()
      )
    }
  }
}
