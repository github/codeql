/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unvalidated URL redirection problems on the server side, as well as
 * extension points for adding your own.
 */

import javascript
import RemoteFlowSources

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
      this.(Http::RequestInputAccess).isThirdPartyControllable()
    }
  }

  /**
   * An HTTP redirect, considered as a sink for `Configuration`.
   */
  class RedirectSink extends Sink {
    RedirectSink() { this = any(Http::RedirectInvocation redir).getUrlArgument() }
  }

  /**
   * A definition of the HTTP "Location" header, considered as a sink for
   * `Configuration`.
   */
  class LocationHeaderSink extends Sink {
    LocationHeaderSink() {
      any(Http::ExplicitHeaderDefinition def).definesHeaderValue("location", this)
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

  private class SinkFromModel extends Sink {
    SinkFromModel() { this = ModelOutput::getASinkNode("url-redirection").asSink() }
  }
}
