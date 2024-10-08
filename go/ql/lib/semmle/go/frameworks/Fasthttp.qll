/**
 * Provides classes for working with remote flow sources, sinks and taint propagators
 * from the `github.com/valyala/fasthttp` package.
 */

import go
private import semmle.go.security.RequestForgeryCustomizations

/**
 * Provides classes for working with the [fasthttp](github.com/valyala/fasthttp) package.
 */
module Fasthttp {
  /** Gets the v1 module path `github.com/valyala/fasthttp`. */
  string v1modulePath() { result = "github.com/valyala/fasthttp" }

  /** Gets the path for the root package of fasthttp. */
  string packagePath() { result = package(v1modulePath(), "") }

  private class HeaderWrite extends Http::HeaderWrite::Range, DataFlow::MethodCallNode {
    string methodName;

    HeaderWrite() {
      this.getTarget().hasQualifiedName(packagePath(), "ResponseHeader", methodName) and
      methodName in [
          "Add", "AddBytesK", "AddBytesKV", "AddBytesV", "Set", "SetBytesK", "SetBytesKV",
          "SetCanonical", "SetContentType", "SetContentTypeBytes"
        ]
      or
      this.getTarget().hasQualifiedName(packagePath(), "RequestCtx", methodName) and
      methodName in ["SetContentType", "SetContentTypeBytes", "Success", "SuccessString"]
    }

    override DataFlow::Node getName() {
      methodName =
        [
          "Add", "AddBytesK", "AddBytesKV", "AddBytesV", "Set", "SetBytesK", "SetBytesKV",
          "SetCanonical"
        ] and
      result = this.getArgument(0)
    }

    override string getHeaderName() {
      result = Http::HeaderWrite::Range.super.getHeaderName()
      or
      methodName = ["SetContentType", "SetContentTypeBytes", "Success", "SuccessString"] and
      result = "content-type"
    }

    override DataFlow::Node getValue() {
      if methodName = ["SetContentType", "SetContentTypeBytes", "Success", "SuccessString"]
      then result = this.getArgument(0)
      else result = this.getArgument(1)
    }

    override Http::ResponseWriter getResponseWriter() {
      result.(ResponseWriter).getAHeaderObject() = this
    }
  }

  private class ResponseWriter extends Http::ResponseWriter::Range {
    SsaWithFields v;

    ResponseWriter() {
      this = v.getBaseVariable().getSourceVariable() and
      (
        v.getType().hasQualifiedName(packagePath(), ["Response", "ResponseHeader"]) or
        v.getType().(PointerType).getBaseType().hasQualifiedName(packagePath(), "RequestCtx")
      )
    }

    override DataFlow::Node getANode() { result = v.similar().getAUse().getASuccessor*() }

    /** Gets a header object that corresponds to this HTTP response. */
    DataFlow::MethodCallNode getAHeaderObject() {
      result.getTarget().getName() =
        [
          "Add", "AddBytesK", "AddBytesKV", "AddBytesV", "Set", "SetBytesK", "SetBytesKV",
          "SetCanonical", "SetContentType", "SetContentTypeBytes", "Success", "SuccessString"
        ] and
      this.getANode() = result.getReceiver()
    }
  }

  private predicate responseBodyWriterResult(DataFlow::Node src) {
    exists(Method responseBodyWriter |
      responseBodyWriter.hasQualifiedName(packagePath(), "Response", "BodyWriter") and
      src = responseBodyWriter.getACall().getResult(0)
    )
  }

  private predicate writerSinkAndBody(DataFlow::Node sink, DataFlow::Node body) {
    exists(DataFlow::CallNode writerCall |
      writerCall = any(Method write | write.hasQualifiedName("io", "Writer", "Write")).getACall() and
      sink = writerCall.getReceiver() and
      body = writerCall.getArgument(0)
    )
    or
    exists(DataFlow::CallNode writerCall |
      writerCall =
        any(Function fprintf | fprintf.hasQualifiedName("fmt", ["Fprint", "Fprintf", "Fprintln"]))
            .getACall() and
      sink = writerCall.getArgument(0) and
      body = writerCall.getSyntacticArgument(any(int i | i > 1))
    )
    or
    exists(DataFlow::CallNode writerCall |
      writerCall =
        any(Function ioCopy |
          ioCopy.hasQualifiedName("io", ["copy", "CopyBuffer", "CopyN", "WriteString"])
        ).getACall() and
      sink = writerCall.getArgument(0) and
      body = writerCall.getArgument(1)
    )
    or
    exists(DataFlow::CallNode writerCall |
      writerCall =
        any(Function ioTeeReader | ioTeeReader.hasQualifiedName("io", "TeeReader")).getACall() and
      sink = writerCall.getArgument(1) and
      body = writerCall.getArgument(0)
    )
    or
    exists(DataFlow::CallNode writerCall |
      writerCall =
        any(Method bufioWriteTo | bufioWriteTo.hasQualifiedName("bufio", "Reader", "WriteTo"))
            .getACall() and
      sink = writerCall.getArgument(0) and
      body = writerCall.getReceiver()
    )
    or
    exists(DataFlow::CallNode writerCall |
      writerCall =
        any(Method bytes | bytes.hasQualifiedName("bytes", "Buffer", "WriteTo")).getACall() and
      sink = writerCall.getArgument(0) and
      body = writerCall.getReceiver()
    )
  }

  private predicate writerSink(DataFlow::Node sink) { writerSinkAndBody(sink, _) }

  private module ResponseBodyWriterFlow =
    DataFlow::SimpleGlobal<responseBodyWriterResult/1>::Graph<writerSink/1>;

  private class ResponseBody extends Http::ResponseBody::Range {
    DataFlow::MethodCallNode responseWriterMethodCall;

    ResponseBody() {
      exists(Method m |
        m.hasQualifiedName(packagePath(), "Response",
          [
            "AppendBody", "AppendBodyString", "SetBody", "SetBodyRaw", "SetBodyStream",
            "SetBodyString", "Success", "SuccessString"
          ]) and
        responseWriterMethodCall = m.getACall() and
        this = responseWriterMethodCall.getArgument(0)
        or
        m.hasQualifiedName(packagePath(), "RequestCtx", ["Success", "SuccessString"]) and
        responseWriterMethodCall = m.getACall() and
        this = responseWriterMethodCall.getArgument(1)
      )
      or
      exists(ResponseBodyWriterFlow::PathNode source, ResponseBodyWriterFlow::PathNode sink |
        ResponseBodyWriterFlow::flowPath(source, sink) and
        responseWriterMethodCall = source.getNode() and
        writerSinkAndBody(sink.getNode(), this)
      )
    }

    override Http::ResponseWriter getResponseWriter() {
      result.getANode() = responseWriterMethodCall.getReceiver()
    }
  }

  /**
   * Provide models for sanitizer/Dangerous Functions of fasthttp.
   */
  module Functions {
    /**
     * DEPRECATED: Use `FileSystemAccess::Range` instead.
     *
     * A function that doesn't sanitize user-provided file paths.
     */
    deprecated class FileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
      FileSystemAccess() {
        exists(Function f |
          f.hasQualifiedName(packagePath(),
            [
              "SaveMultipartFile", "ServeFile", "ServeFileBytes", "ServeFileBytesUncompressed",
              "ServeFileUncompressed"
            ]) and
          this = f.getACall()
        )
      }

      override DataFlow::Node getAPathArgument() { result = this.getArgument(1) }
    }

    /**
     * A function that can be used as a sanitizer for XSS.
     */
    class HtmlQuoteSanitizer extends EscapeFunction::Range {
      boolean isHtmlEscape;

      HtmlQuoteSanitizer() {
        this.hasQualifiedName(packagePath(), ["AppendHTMLEscape", "AppendHTMLEscapeBytes"]) and
        isHtmlEscape = true
        or
        this.hasQualifiedName(packagePath(), "AppendQuotedArg") and isHtmlEscape = false
      }

      override string kind() {
        isHtmlEscape = true and result = "html"
        or
        isHtmlEscape = false and result = "url"
      }
    }

    /**
     * DEPRECATED: Use `RequestForgery::Sink` instead.
     *
     * A function that sends HTTP requests.
     *
     * Get* send a HTTP GET request.
     * Post send a HTTP POST request.
     * These functions first argument is a URL.
     */
    deprecated class RequestForgerySink extends RequestForgery::Sink {
      RequestForgerySink() {
        exists(Function f |
          f.hasQualifiedName(packagePath(), ["Get", "GetDeadline", "GetTimeout", "Post"]) and
          this = f.getACall().getArgument(1)
        )
      }

      override DataFlow::Node getARequest() { result = this }

      override string getKind() { result = "URL" }
    }

    /**
     * DEPRECATED: Use `RequestForgery::Sink` instead.
     *
     * A function that create initial connection to a TCP address.
     * Following Functions only accept TCP address + Port in their first argument.
     */
    deprecated class RequestForgerySinkDial extends RequestForgery::Sink {
      RequestForgerySinkDial() {
        exists(Function f |
          f.hasQualifiedName(packagePath(),
            ["Dial", "DialDualStack", "DialDualStackTimeout", "DialTimeout"]) and
          this = f.getACall().getArgument(0)
        )
      }

      override DataFlow::Node getARequest() { result = this }

      override string getKind() { result = "TCP Addr + Port" }
    }
  }

  /**
   * DEPRECATED
   *
   * Provide modeling for fasthttp.URI Type.
   */
  deprecated module URI {
    /**
     * DEPRECATED: Use `RemoteFlowSource::Range` instead.
     */
    deprecated class UntrustedFlowSource = RemoteFlowSource;

    /**
     * DEPRECATED: Use `RemoteFlowSource::Range` instead.
     *
     * The methods as Remote user controllable source which are part of the incoming URL.
     */
    deprecated class RemoteFlowSource extends RemoteFlowSource::Range instanceof DataFlow::Node {
      RemoteFlowSource() {
        exists(Method m |
          m.hasQualifiedName(packagePath(), "URI",
            ["FullURI", "LastPathSegment", "Path", "PathOriginal", "QueryString", "String"]) and
          this = m.getACall().getResult(0)
        )
      }
    }
  }

  /**
   * DEPRECATED
   *
   * Provide modeling for fasthttp.Args Type.
   */
  deprecated module Args {
    /**
     * DEPRECATED: Use `RemoteFlowSource::Range` instead.
     */
    deprecated class UntrustedFlowSource = RemoteFlowSource;

    /**
     * DEPRECATED: Use `RemoteFlowSource::Range` instead.
     *
     * The methods as Remote user controllable source which are part of the incoming URL Parameters.
     *
     * When support for lambdas has been implemented we should model "VisitAll".
     */
    deprecated class RemoteFlowSource extends RemoteFlowSource::Range instanceof DataFlow::Node {
      RemoteFlowSource() {
        exists(Method m |
          m.hasQualifiedName(packagePath(), "Args",
            ["Peek", "PeekBytes", "PeekMulti", "PeekMultiBytes", "QueryString", "String"]) and
          this = m.getACall().getResult(0)
        )
      }
    }
  }

  /**
   * DEPRECATED
   *
   * Provide modeling for fasthttp.TCPDialer Type.
   */
  deprecated module TcpDialer {
    /**
     * DEPRECATED: Use `RequestForgery::Sink` instead.
     *
     * A method that create initial connection to a TCP address.
     * Provide Methods which can be used as dangerous RequestForgery Sinks.
     * Following Methods only accept TCP address + Port in their first argument.
     */
    deprecated class RequestForgerySinkDial extends RequestForgery::Sink {
      RequestForgerySinkDial() {
        exists(Method m |
          m.hasQualifiedName(packagePath(), "TCPDialer",
            ["Dial", "DialDualStack", "DialDualStackTimeout", "DialTimeout"]) and
          this = m.getACall().getArgument(0)
        )
      }

      override DataFlow::Node getARequest() { result = this }

      override string getKind() { result = "TCP Addr + Port" }
    }
  }

  /**
   * DEPRECATED
   *
   * Provide modeling for fasthttp.Client Type.
   */
  deprecated module Client {
    /**
     * DEPRECATED: Use `RequestForgery::Sink` instead.
     *
     * A method that sends HTTP requests.
     * Get* send a HTTP GET request.
     * Post send a HTTP POST request.
     * these Functions first arguments is a URL.
     */
    deprecated class RequestForgerySink extends RequestForgery::Sink {
      RequestForgerySink() {
        exists(Method m |
          m.hasQualifiedName(packagePath(), "Client", ["Get", "GetDeadline", "GetTimeout", "Post"]) and
          this = m.getACall().getArgument(1)
        )
      }

      override DataFlow::Node getARequest() { result = this }

      override string getKind() { result = "URL" }
    }
  }

  /**
   * DEPRECATED
   *
   * Provide modeling for fasthttp.HostClient Type.
   */
  deprecated module HostClient {
    /**
     * DEPRECATED: Use `RequestForgery::Sink` instead.
     *
     * A method that sends HTTP requests.
     * Get* send a HTTP GET request.
     * Post send a HTTP POST request.
     * these Functions first arguments is a URL.
     */
    deprecated class RequestForgerySink extends RequestForgery::Sink {
      RequestForgerySink() {
        exists(Method m |
          m.hasQualifiedName(packagePath(), "HostClient",
            ["Get", "GetDeadline", "GetTimeout", "Post"]) and
          this = m.getACall().getArgument(1)
        )
      }

      override DataFlow::Node getARequest() { result = this }

      override string getKind() { result = "URL" }
    }
  }

  /**
   * Provide modeling for fasthttp.Response Type.
   */
  deprecated module Response {
    /**
     * DEPRECATED: Use `FileSystemAccess::Range` instead.
     *
     * A Method that sends files from its input.
     * It does not check the input path against path traversal attacks, So it is a dangerous method.
     */
    deprecated class FileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
      FileSystemAccess() {
        exists(Method mcn |
          mcn.hasQualifiedName(packagePath(), "Response", "SendFile") and
          this = mcn.getACall()
        )
      }

      override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
    }
  }

  /**
   * Provide modeling for fasthttp.Request Type.
   */
  module Request {
    /**
     * DEPRECATED: Use `RemoteFlowSource::range` instead.
     */
    deprecated class UntrustedFlowSource = RemoteFlowSource;

    /**
     * DEPRECATED: Use `RemoteFlowSource::range` instead.
     *
     * The methods as Remote user controllable source which can be many part of request.
     */
    deprecated class RemoteFlowSource extends RemoteFlowSource::Range instanceof DataFlow::Node {
      RemoteFlowSource() {
        exists(Method m |
          m.hasQualifiedName(packagePath(), "Request",
            [
              "Body", "BodyGunzip", "BodyInflate", "BodyStream", "BodyUnbrotli", "BodyUncompressed",
              "Host", "RequestURI"
            ]) and
          this = m.getACall().getResult(0)
        )
        or
        exists(Method m |
          m.hasQualifiedName(packagePath(), "Request",
            ["ReadBody", "ReadLimitBody", "ContinueReadBodyStream", "ContinueReadBody"]) and
          this = m.getACall().getArgument(0)
        )
      }
    }

    /**
     * DEPRECATED: Use `RequestForgery::Sink` instead.
     *
     * A method that create the URL and Host parts of a `Request` type.
     *
     * This instance of `Request` type can be used in some functions/methods
     * like `func Do(req *Request, resp *Response) error` that will lead to server side request forgery vulnerability.
     */
    deprecated class RequestForgerySink extends RequestForgery::Sink {
      RequestForgerySink() {
        exists(Method m |
          m.hasQualifiedName(packagePath(), "Request",
            ["SetHost", "SetHostBytes", "SetRequestURI", "SetRequestURIBytes", "SetURI"]) and
          this = m.getACall().getArgument(0)
        )
      }

      override DataFlow::Node getARequest() { result = this }

      override string getKind() { result = "URL" }
    }
  }

  /**
   * Provide modeling for fasthttp.RequestCtx Type.
   */
  module RequestCtx {
    /**
     * DEPRECATED: Use `FileSystemAccess::Range` instead.
     *
     * The Methods that don't sanitize user provided file paths.
     */
    deprecated class FileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
      FileSystemAccess() {
        exists(Method mcn |
          mcn.hasQualifiedName(packagePath(), "RequestCtx", ["SendFile", "SendFileBytes"]) and
          this = mcn.getACall()
        )
      }

      override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
    }

    /**
     * DEPRECATED: Use `RemoteFlowSource` instead.
     */
    deprecated class UntrustedFlowSource = RemoteFlowSource;

    /**
     * DEPRECATED: Use `RemoteFlowSource` instead.
     *
     * The methods as Remote user controllable source which are generally related to HTTP request.
     *
     * When support for lambdas has been implemented we should model "VisitAll", "VisitAllCookie", "VisitAllInOrder", "VisitAllTrailer".
     */
    deprecated class RemoteFlowSource extends RemoteFlowSource::Range instanceof DataFlow::Node {
      RemoteFlowSource() {
        exists(Method m |
          m.hasQualifiedName(packagePath(), "RequestCtx",
            [
              "Host", "Path", "PostBody", "Referer", "RequestBodyStream", "RequestURI", "String",
              "UserAgent"
            ]) and
          this = m.getACall().getResult(0)
        )
      }
    }
  }

  /**
   * DEPRECATED
   *
   * Provide Methods of fasthttp.RequestHeader which mostly used as remote user controlled sources.
   */
  deprecated module RequestHeader {
    /**
     * DEPRECATED: Use `RemoteFlowSource::Range` instead.
     */
    deprecated class UntrustedFlowSource = RemoteFlowSource;

    /**
     * DEPRECATED: Use `RemoteFlowSource::Range` instead.
     *
     * The methods as Remote user controllable source which are mostly related to HTTP Request Headers.
     *
     * When support for lambdas has been implemented we should model "VisitAll", "VisitAllCookie", "VisitAllInOrder", "VisitAllTrailer".
     */
    deprecated class RemoteFlowSource extends RemoteFlowSource::Range instanceof DataFlow::Node {
      RemoteFlowSource() {
        exists(Method m |
          m.hasQualifiedName(packagePath(), "RequestHeader",
            [
              "ContentEncoding", "ContentType", "Cookie", "CookieBytes", "Header", "Host",
              "MultipartFormBoundary", "Peek", "PeekAll", "PeekBytes", "PeekKeys",
              "PeekTrailerKeys", "RawHeaders", "Referer", "RequestURI", "String", "TrailerHeader",
              "UserAgent"
            ]) and
          this = m.getACall().getResult(0)
        )
      }
    }
  }
}
