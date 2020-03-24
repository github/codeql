/**
 * Provides classes for working with HTTP-related concepts such as requests and responses.
 */

import go

private module StdlibHttp {
  /** An access to an HTTP request field whose value may be controlled by an untrusted user. */
  private class UserControlledRequestField extends UntrustedFlowSource::Range,
    DataFlow::FieldReadNode {
    UserControlledRequestField() {
      exists(string fieldName | this.getField().hasQualifiedName("net/http", "Request", fieldName) |
        fieldName = "Body" or fieldName = "Form" or fieldName = "Header" or fieldName = "URL"
      )
    }
  }

  private class HeaderGet extends TaintTracking::FunctionModel, Method {
    HeaderGet() { this.hasQualifiedName("net/http", "Header", "Get") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  private class HeaderValues extends TaintTracking::FunctionModel, Method {
    HeaderValues() { this.hasQualifiedName("net/http", "Header", "Values") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
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

  private class HeaderWriteCall extends HTTP::HeaderWrite::Range, DataFlow::MethodCallNode {
    HeaderWriteCall() {
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
      exists(Function newRequest |
        newRequest.hasQualifiedName("net/http", "NewRequest") and
        this = newRequest.getACall().getArgument(2)
      )
      or
      exists(Field body, Type request |
        request.hasQualifiedName("net/http", "Request") and
        body = request.getField("Body") and
        this = body.getAWrite().getRhs()
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

  /** A call to a function in the `net/http` package that performs an HTTP request to a URL. */
  private class RequestCall extends HTTP::ClientRequest::Range, DataFlow::CallNode {
    RequestCall() {
      exists(string functionName |
        (
          this.getTarget().hasQualifiedName("net/http", functionName)
          or
          this.getTarget().(Method).hasQualifiedName("net/http", "Client", functionName)
        ) and
        (functionName = "Get" or functionName = "Post" or functionName = "PostForm")
      )
    }

    /** Gets the URL of the request. */
    override DataFlow::Node getUrl() { result = this.getArgument(0) }
  }
}
