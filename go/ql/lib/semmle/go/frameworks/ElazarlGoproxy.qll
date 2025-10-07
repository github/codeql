/**
 * Provides classes for working with concepts relating to the [github.com/elazarl/goproxy](https://pkg.go.dev/github.com/elazarl/goproxy) package.
 */

import go

/**
 * Provides classes for working with concepts relating to the [github.com/elazarl/goproxy](https://pkg.go.dev/github.com/elazarl/goproxy) package.
 */
module ElazarlGoproxy {
  /** Gets the package name. */
  string packagePath() { result = package("github.com/elazarl/goproxy", "") }

  private class NewResponse extends Http::HeaderWrite::Range, DataFlow::CallNode {
    NewResponse() { this.getTarget().hasQualifiedName(packagePath(), "NewResponse") }

    override string getHeaderName() { this.definesHeader(result, _) }

    override string getHeaderValue() { this.definesHeader(_, result) }

    override DataFlow::Node getName() { none() }

    override DataFlow::Node getValue() { result = this.getArgument([1, 2]) }

    override predicate definesHeader(string header, string value) {
      header = "status" and value = this.getArgument(2).getIntValue().toString()
      or
      header = "content-type" and value = this.getArgument(1).getStringValue()
    }

    override Http::ResponseWriter getResponseWriter() { none() }
  }

  /** A body argument to a `NewResponse` call. */
  private class NewResponseBody extends Http::ResponseBody::Range {
    NewResponse call;

    NewResponseBody() { this = call.getArgument(3) }

    override DataFlow::Node getAContentTypeNode() { result = call.getArgument(1) }

    override Http::ResponseWriter getResponseWriter() { none() }
  }

  private class TextResponse extends Http::HeaderWrite::Range, DataFlow::CallNode {
    TextResponse() { this.getTarget().hasQualifiedName(packagePath(), "TextResponse") }

    override string getHeaderName() { this.definesHeader(result, _) }

    override string getHeaderValue() { this.definesHeader(_, result) }

    override DataFlow::Node getName() { none() }

    override DataFlow::Node getValue() { none() }

    override predicate definesHeader(string header, string value) {
      header = "status" and value = "200"
      or
      header = "content-type" and value = "text/plain"
    }

    override Http::ResponseWriter getResponseWriter() { none() }
  }

  /** A body argument to a `TextResponse` call. */
  private class TextResponseBody extends Http::ResponseBody::Range, TextResponse {
    TextResponse call;

    TextResponseBody() { this = call.getArgument(2) }

    override DataFlow::Node getAContentTypeNode() { result = call.getArgument(1) }

    override Http::ResponseWriter getResponseWriter() { none() }
  }

  /** A handler attached to a goproxy proxy type. */
  private class ProxyHandler extends Http::RequestHandler::Range {
    DataFlow::MethodCallNode handlerReg;

    ProxyHandler() {
      handlerReg
          .getTarget()
          .hasQualifiedName(packagePath(), "ReqProxyConds", ["Do", "DoFunc", "HandleConnect"]) and
      this = handlerReg.getArgument(0)
    }

    override predicate guardedBy(DataFlow::Node check) {
      // note OnResponse is not modeled, as that server responses are not currently considered untrusted input
      exists(DataFlow::MethodCallNode onreqcall |
        onreqcall.getTarget().hasQualifiedName(packagePath(), "ProxyHttpServer", "OnRequest")
      |
        handlerReg.getReceiver() = onreqcall.getASuccessor*() and
        check = onreqcall.getSyntacticArgument(0)
      )
    }
  }

  private class ProxyLogFunction extends StringOps::Formatting::Range, Method {
    ProxyLogFunction() { this.hasQualifiedName(packagePath(), "ProxyCtx", ["Logf", "Warnf"]) }

    override int getFormatStringIndex() { result = 0 }
  }
}
