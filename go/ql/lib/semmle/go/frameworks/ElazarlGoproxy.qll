/**
 * Provides classes for working with concepts relating to the [github.com/elazarl/goproxy](https://pkg.go.dev/github.com/elazarl/goproxy) package.
 */

import go
private import semmle.go.StringOps

/**
 * Provides classes for working with concepts relating to the [github.com/elazarl/goproxy](https://pkg.go.dev/github.com/elazarl/goproxy) package.
 */
module ElazarlGoproxy {
  /** Gets the package name. */
  string packagePath() { result = package("github.com/elazarl/goproxy", "") }

  private class NewResponse extends HTTP::HeaderWrite::Range, DataFlow::CallNode {
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

    override HTTP::ResponseWriter getResponseWriter() { none() }
  }

  /** A body argument to a `NewResponse` call. */
  private class NewResponseBody extends HTTP::ResponseBody::Range {
    NewResponse call;

    NewResponseBody() { this = call.getArgument(3) }

    override DataFlow::Node getAContentTypeNode() { result = call.getArgument(1) }

    override HTTP::ResponseWriter getResponseWriter() { none() }
  }

  private class TextResponse extends HTTP::HeaderWrite::Range, DataFlow::CallNode {
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

    override HTTP::ResponseWriter getResponseWriter() { none() }
  }

  /** A body argument to a `TextResponse` call. */
  private class TextResponseBody extends HTTP::ResponseBody::Range, TextResponse {
    TextResponse call;

    TextResponseBody() { this = call.getArgument(2) }

    override DataFlow::Node getAContentTypeNode() { result = call.getArgument(1) }

    override HTTP::ResponseWriter getResponseWriter() { none() }
  }

  /** A handler attached to a goproxy proxy type. */
  private class ProxyHandler extends HTTP::RequestHandler::Range {
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
        check = onreqcall.getArgument(0)
      )
    }
  }

  private class UserControlledRequestData extends UntrustedFlowSource::Range {
    UserControlledRequestData() {
      exists(DataFlow::FieldReadNode frn | this = frn |
        // liberally consider ProxyCtx.UserData to be untrusted; it's a data field set by a request handler
        frn.getField().hasQualifiedName(packagePath(), "ProxyCtx", "UserData")
      )
      or
      exists(DataFlow::MethodCallNode call | this = call |
        call.getTarget().hasQualifiedName(packagePath(), "ProxyCtx", "Charset")
      )
    }
  }

  private class ProxyLogFunction extends StringOps::Formatting::Range, Method {
    ProxyLogFunction() { this.hasQualifiedName(packagePath(), "ProxyCtx", ["Logf", "Warnf"]) }

    override int getFormatStringIndex() { result = 0 }

    override int getFirstFormattedParameterIndex() { result = 1 }
  }

  private class ProxyLog extends LoggerCall::Range, DataFlow::MethodCallNode {
    ProxyLog() { this.getTarget() instanceof ProxyLogFunction }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // Methods:
      // signature: func CertStorage.Fetch(hostname string, gen func() (*tls.Certificate, error)) (*tls.Certificate, error)
      //
      // `hostname` excluded because if the cert storage or generator function themselves have not
      // been tainted, `hostname` would be unlikely to fetch user-controlled data
      this.hasQualifiedName(packagePath(), "CertStorage", "Fetch") and
      (inp.isReceiver() or inp.isParameter(1)) and
      outp.isResult(0)
    }

    override predicate hasTaintFlow(FunctionInput i, FunctionOutput o) { i = inp and o = outp }
  }
}
