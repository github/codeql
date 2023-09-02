/** Provides models of commonly used functions and types in the fasthttp packages. */

import go
private import semmle.go.security.RequestForgeryCustomizations
private import semmle.go.security.SafeUrlFlowCustomizations
import semmle.go.security.Xss

/** Provides models of commonly used functions and types in the fasthttp packages. */
module Fasthttp {
  bindingset[this]
  abstract class AdditionalStep extends string {
    /**
     * Holds if `pred` to `succ` is an additional taint-propagating step for this query.
     */
    abstract predicate hasTaintStep(DataFlow::Node pred, DataFlow::Node succ);
  }

  string fasthttpPackage() { result = "github.com/valyala/fasthttp" }

  module Functions {
    private class Redirect extends Http::Redirect::Range, DataFlow::CallNode {
      Redirect() {
        exists(DataFlow::Function f |
          f.hasQualifiedName("github.com/valyala/fasthttp", "DoRedirects") and this = f.getACall()
        )
      }

      override DataFlow::Node getUrl() { result = this.getArgument(0) }

      override Http::ResponseWriter getResponseWriter() { result.getANode() = this.getArgument(1) }
    }

    private class HtmlQuoteSanitizer extends SharedXss::Sanitizer {
      HtmlQuoteSanitizer() {
        exists(DataFlow::CallNode c |
          c.getTarget()
              .hasQualifiedName("github.com/valyala/fasthttp",
                ["AppendHTMLEscape", "AppendHTMLEscapeBytes", "AppendQuotedArg"])
        |
          this = c.getArgument(1)
        )
      }
    }

    class SSRFSink extends RequestForgery::Sink {
      SSRFSink() {
        exists(DataFlow::Function f |
          f.hasQualifiedName("github.com/valyala/fasthttp",
            [
              "DialDualStack", "Dial", "DialTimeout", "DialDualStackTimeout", "Get", "GetDeadline",
              "GetTimeout", "Post", "Do", "DoDeadline", "DoTimeout", "Write", "Write", "Write",
              "Write", "Write"
            ]) and
          this = f.getACall().getArgument(0)
        )
      }

      override DataFlow::Node getARequest() { result = this }

      override string getKind() { result = "URL" }
    }
  }

  module RequestHeader {
    class UntrustedFlowSource extends UntrustedFlowSource::Range instanceof DataFlow::Node {
      UntrustedFlowSource() {
        exists(DataFlow::Method m |
          m.hasQualifiedName("github.com/valyala/fasthttp.RequestHeader",
            [
              "Header", "TrailerHeader", "RequestURI", "Host", "UserAgent", "ContentEncoding",
              "ContentType", "Cookie", "CookieBytes", "MultipartFormBoundary", "Peek", "PeekAll",
              "PeekBytes", "PeekKeys", "PeekTrailerKeys", "Referer", "RawHeaders"
            ]) and
          this = m.getACall()
          or
          m.hasQualifiedName("github.com/valyala/fasthttp.RequestHeader", ["Write"]) and
          this = m.getACall().getArgument(0)
        )
      }
    }
  }

  module URI {
    class URIAdditionalStep extends AdditionalStep {
      URIAdditionalStep() { this = "URI additioanl steps" }

      override predicate hasTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
        exists(DataFlow::MethodCallNode m, DataFlow::Variable frn |
          m.getTarget()
              .hasQualifiedName("github.com/valyala/fasthttp.URI", ["SetHost", "SetHostBytes"]) and
          pred = m.getArgument(0) and
          frn.getARead() = m.getReceiver() and
          succ = frn.getARead()
        )
      }
    }

    class UntrustedFlowSource extends UntrustedFlowSource::Range instanceof DataFlow::Node {
      UntrustedFlowSource() {
        exists(DataFlow::Method m |
          m.hasQualifiedName("github.com/valyala/fasthttp.URI",
            ["Path", "PathOriginal", "LastPathSegment", "FullURI", "QueryString", "String"]) and
          this = m.getACall()
          or
          m.hasQualifiedName("github.com/valyala/fasthttp.URI", "WriteTo") and
          this = m.getACall().getArgument(0)
        )
      }
    }
  }

  module Args {
    class UntrustedFlowSource extends UntrustedFlowSource::Range instanceof DataFlow::Node {
      UntrustedFlowSource() {
        exists(DataFlow::Method m |
          m.hasQualifiedName("github.com/valyala/fasthttp.Args",
            ["Peek", "PeekBytes", "PeekMulti", "PeekMultiBytes", "QueryString", "String"]) and
          this = m.getACall()
          or
          m.hasQualifiedName("github.com/valyala/fasthttp.Args", "WriteTo") and
          this = m.getACall().getArgument(0)
        )
      }
    }
  }

  module TCPDialer {
    class SSRFSink extends RequestForgery::Sink {
      SSRFSink() {
        exists(DataFlow::Method m |
          m.hasQualifiedName("github.com/valyala/fasthttp.TCPDialer",
            ["Dial", "DialTimeout", "DialDualStack", "DialDualStackTimeout"]) and
          this = m.getACall().getArgument(0)
        )
      }

      override DataFlow::Node getARequest() { result = this }

      override string getKind() { result = "Host" }
    }
  }

  module Client {
    class SSRFSink extends RequestForgery::Sink {
      SSRFSink() {
        exists(DataFlow::Method m |
          m.hasQualifiedName("github.com/valyala/fasthttp.Client",
            ["Get", "GetDeadline", "GetTimeout", "Post", "Do", "DoDeadline", "DoTimeout"]) and
          this = m.getACall().getArgument(0)
        )
      }

      override DataFlow::Node getARequest() { result = this }

      override string getKind() { result = "URL" }
    }
  }

  module Request {
    class RequestAdditionalStep extends AdditionalStep {
      RequestAdditionalStep() { this = "Request additioanl steps" }

      override predicate hasTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
        exists(DataFlow::MethodCallNode m, DataFlow::Variable frn |
          m.getTarget()
              .hasQualifiedName("github.com/valyala/fasthttp.Request",
                ["SetRequestURI", "SetRequestURIBytes", "SetURI", "SetHost", "SetHostBytes"]) and
          pred = m.getArgument(0) and
          frn.getARead() = m.getReceiver() and
          succ = frn.getARead()
        )
      }
    }

    class UntrustedFlowSource extends UntrustedFlowSource::Range instanceof DataFlow::Node {
      UntrustedFlowSource() {
        exists(DataFlow::Method m |
          m.hasQualifiedName("github.com/valyala/fasthttp.Request",
            [
              "Host", "RequestURI", "Body", "BodyGunzip", "BodyInflate", "BodyUnbrotli",
              "BodyStream", "BodyUncompressed"
            ]) and
          this = m.getACall()
          or
          m.hasQualifiedName("github.com/valyala/fasthttp.Request",
            [
              "BodyWriteTo", "WriteTo", "ReadBody", "ReadLimitBody", "ContinueReadBodyStream",
              "ContinueReadBody"
            ]) and
          this = m.getACall().getArgument(0)
        )
      }
    }
  }

  module Response {
    class HttpResponseBodySink extends SharedXss::Sink {
      HttpResponseBodySink() {
        exists(DataFlow::Method m |
          m.hasQualifiedName("github.com/valyala/fasthttp.Response",
            [
              "AppendBody", "AppendBodyString", "SetBody", "SetBodyString", "SetBodyRaw",
              "SetBodyStream"
            ]) and
          this = m.getACall().getArgument(0)
        )
      }
    }
  }

  module RequestCtx {
    private class Redirect extends Http::Redirect::Range, DataFlow::CallNode {
      Redirect() {
        exists(DataFlow::Function f |
          f.hasQualifiedName("github.com/valyala/fasthttp", ["Redirect", "RedirectBytes"]) and
          this = f.getACall()
        )
      }

      override DataFlow::Node getUrl() { result = this.getArgument(0) }

      override Http::ResponseWriter getResponseWriter() { none() }
    }

    class UntrustedFlowSource extends UntrustedFlowSource::Range instanceof DataFlow::Node {
      UntrustedFlowSource() {
        exists(DataFlow::Method m |
          m.hasQualifiedName("github.com/valyala/fasthttp.RequestCtx",
            ["Path", "Referer", "PostBody", "RequestBodyStream", "RequestURI", "UserAgent", "Host"]) and
          this = m.getACall()
        )
      }
    }
  }
}
