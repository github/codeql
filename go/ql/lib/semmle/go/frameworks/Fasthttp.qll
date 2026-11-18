/**
 * Provides classes for working with remote flow sources, sinks and taint propagators
 * from the `github.com/valyala/fasthttp` package.
 */
overlay[local?]
module;

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
      this = v.getBaseDefinition().getSourceVariable() and
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
  }
}
