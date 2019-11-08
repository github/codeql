/**
 * Provides classes for working with HTTP-related concepts such as requests and responses.
 */

import go

private module StdlibHttp {
  /** An access to an HTTP request field whose value may be controlled by an untrusted user. */
  private class UserControlledRequestField extends UntrustedFlowSource::Range, DataFlow::ExprNode {
    override SelectorExpr expr;

    UserControlledRequestField() {
      exists(Type req, Type baseType, string fieldName |
        req.hasQualifiedName("net/http", "Request") and
        baseType = expr.getBase().getType() and
        fieldName = expr.getSelector().getName() and
        (baseType = req or baseType = req.getPointerType()) and
        (fieldName = "Body" or fieldName = "Form" or fieldName = "Header" or fieldName = "URL")
      )
    }
  }

  private class StdlibResponseWriter extends HTTP::ResponseWriter::Range {
    StdlibResponseWriter() { this.getType().implements("net/http", "ResponseWriter") }

    /** Gets a header object that corresponds to this HTTP response. */
    DataFlow::MethodCallNode getAHeaderObject() {
      result.getTarget().hasQualifiedName("net/http", _, "Header") and
      this.getARead() = result.getReceiver()
    }
  }

  private class HeaderCall extends HTTP::HeaderWrite::Range, DataFlow::MethodCallNode {
    HeaderCall() {
      this.getTarget().hasQualifiedName("net/http", "Header", "Add") or
      this.getTarget().hasQualifiedName("net/http", "Header", "Set")
    }

    override DataFlow::Node getName() { result = this.getArgument(0) }

    override DataFlow::Node getValue() { result = this.getArgument(1) }

    override HTTP::ResponseWriter getResponseWriter() {
      // find `v` in
      // ```
      // header := v.Header()
      // header.Add(...)
      // ```
      result.(StdlibResponseWriter).getAHeaderObject().getASuccessor*() = this.getReceiver()
    }
  }

  private class MapWrite extends HTTP::HeaderWrite::Range, DataFlow::Node {
    Write write;
    DataFlow::Node index;
    DataFlow::Node rhs;

    MapWrite() {
      this.getType().hasQualifiedName("net/http", "Header") and
      write.writesElement(this, index, rhs)
    }

    override DataFlow::Node getName() { result = index }

    override DataFlow::Node getValue() { result = rhs }

    override HTTP::ResponseWriter getResponseWriter() {
      // find `v` in
      // ```
      // header := v.Header()
      // header[...] = ...
      // ```
      result.(StdlibResponseWriter).getAHeaderObject().getASuccessor*() = this
    }
  }

  private class ResponseWriteHeaderCall extends HTTP::HeaderWrite::Range, DataFlow::MethodCallNode {
    ResponseWriteHeaderCall() {
      this.getTarget().implements("net/http", "ResponseWriter", "WriteHeader")
    }

    override string getHeaderName() { result = "status" }

    override predicate definesHeader(string header, string value) {
      header = "status" and value = this.getValue().getIntValue().toString()
    }

    override DataFlow::Node getName() { none() }

    override DataFlow::Node getValue() { result = this.getArgument(0) }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = this.getReceiver() }
  }

  private class RequestBody extends HTTP::RequestBody::Range, DataFlow::ExprNode {
    RequestBody() {
      exists(DataFlow::CallNode newRequestCall |
        newRequestCall.getTarget().hasQualifiedName("net/http", "NewRequest")
      |
        this = newRequestCall.getArgument(2)
      )
      or
      exists(Write w, DataFlow::Node base, Field body, Type request |
        w.writesField(base, body, this) and
        request.hasQualifiedName("net/http", "Request") and
        request.getPointerType() = base.getType().getUnderlyingType() and
        body.getName() = "Body"
      )
    }
  }

  private class ResponseBody extends HTTP::ResponseBody::Range, DataFlow::ArgumentNode {
    int arg;

    ResponseBody() {
      exists(DataFlow::CallNode call |
        call.getTarget().(Method).implements("net/http", "ResponseWriter", "Write") and
        arg = 0
        or
        (
          call.getTarget().hasQualifiedName("fmt", "Fprintf")
          or
          call.getTarget().hasQualifiedName("io", "WriteString")
        ) and
        call.getArgument(0).getType().hasQualifiedName("net/http", "ResponseWriter") and
        arg >= 1
      |
        this = call.getArgument(arg)
      )
    }

    override HTTP::ResponseWriter getResponseWriter() {
      // the response writer is the receiver of this call
      result.getANode() = this.getCall().(DataFlow::MethodCallNode).getReceiver()
      or
      // the response writer is an argument to Fprintf or WriteString
      arg >= 1 and
      result.getANode() = this.getCall().getArgument(0)
    }
  }

  private class RedirectCall extends HTTP::Redirect::Range, DataFlow::CallNode {
    RedirectCall() { this.getTarget().hasQualifiedName("net/http", "Redirect") }

    override DataFlow::Node getUrl() { result = this.getArgument(2) }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = this.getArgument(0) }
  }
}
