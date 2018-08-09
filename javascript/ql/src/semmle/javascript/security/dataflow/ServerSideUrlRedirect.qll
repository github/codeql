/**
 * Provides a taint-tracking configuration for reasoning about unvalidated URL
 * redirection problems on the server side.
 */

import javascript
import RemoteFlowSources
import UrlConcatenation

module ServerSideUrlRedirect {
  /**
   * A data flow source for unvalidated URL redirect vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for unvalidated URL redirect vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Holds if this sink may redirect to a non-local URL.
     */
    predicate maybeNonLocal() {
      exists (Expr prefix | prefix = getAPrefix(this) |
        not exists(prefix.getStringValue())
        or
        exists (string prefixVal | prefixVal = prefix.getStringValue() |
          // local URLs (i.e., URLs that start with `/` not followed by `\` or `/`,
          // or that start with `~/`) are unproblematic
          not prefixVal.regexpMatch("/[^\\\\/].*|~/.*") and
          // so are localhost URLs
          not prefixVal.regexpMatch("(\\w+:)?//localhost[:/].*")
        )
      )
    }
  }
  
  /**
   * Gets a node that is transitively reachable from `nd` along prefix predecessor edges.
   */
  private DataFlow::Node prefixCandidate(Sink sink) {
    result = sink or
    result = prefixCandidate(sink).getAPredecessor() or
    result = StringConcatenation::getFirstOperand(prefixCandidate(sink))
  }

  /**
   * Gets an expression that may end up being a prefix of the string concatenation `nd`.
   */
  private Expr getAPrefix(Sink sink) {
    exists (DataFlow::Node prefix |
      prefix = prefixCandidate(sink) and
      not exists(StringConcatenation::getFirstOperand(prefix)) and
      not exists(prefix.getAPredecessor()) and
      result = prefix.asExpr()
    )
  }

  /**
   * A sanitizer for unvalidated URL redirect vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint-tracking configuration for reasoning about unvalidated URL redirections.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ServerSideUrlRedirect" }

    override predicate isSource(DataFlow::Node source) {
      source instanceof Source
    }

    override predicate isSink(DataFlow::Node sink) {
      sink.(Sink).maybeNonLocal()
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizer(DataFlow::Node source, DataFlow::Node sink) {
      sanitizingPrefixEdge(source, sink)
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
      guard instanceof LocalUrlSanitizingGuard
    }

  }

  /** A source of remote user input, considered as a flow source for URL redirects. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * An HTTP redirect, considered as a sink for `Configuration`.
   */
  class RedirectSink extends Sink, DataFlow::ValueNode {
    RedirectSink() {
      astNode = any(HTTP::RedirectInvocation redir).getUrlArgument()
    }
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
    LocalUrlSanitizingGuard() {
      this.getCalleeName().regexpMatch("(?i)(is_?)?local_?url")
    }

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
      exists (ReactNative::WebViewElement webView, DataFlow::SourceNode source, string prop |
        source = webView and prop = "url" or
        source = webView.getAPropertyWrite("source").getRhs().getALocalSource() and prop = "uri" |
        this = source.getAPropertyWrite(prop).getRhs()
      )
    }
  }
}

/** DEPRECATED: Use `ServerSideUrlRedirect::Source` instead. */
deprecated class ServerSideUrlRedirectSource = ServerSideUrlRedirect::Source;

/** DEPRECATED: Use `ServerSideUrlRedirect::Sink` instead. */
deprecated class ServerSideUrlRedirectSink = ServerSideUrlRedirect::Sink;

/** DEPRECATED: Use `ServerSideUrlRedirect::Sanitizer` instead. */
deprecated class ServerSideUrlRedirectSanitizer = ServerSideUrlRedirect::Sanitizer;

/** DEPRECATED: Use `ServerSideUrlRedirect::Configuration` instead. */
deprecated class ServerSideUrlRedirectDataFlowConfiguration = ServerSideUrlRedirect::Configuration;
