/**
 * Provides classes modeling security-relevant aspects of the `net/http` package.
 */

import go
private import semmle.go.dataflow.internal.DataFlowPrivate
private import semmle.go.dataflow.internal.FlowSummaryImpl::Private

/** Provides models of commonly used functions in the `net/http` package. */
module NetHttp {
  /** The declaration of a variable which either is or has a field that implements the http.ResponseWriter type */
  private class StdlibResponseWriter extends Http::ResponseWriter::Range {
    SsaWithFields v;

    StdlibResponseWriter() {
      this = v.getBaseVariable().getSourceVariable() and
      exists(Type t | t.implements("net/http", "ResponseWriter") | v.getType() = t)
    }

    override DataFlow::Node getANode() { result = v.similar().getAUse().getASuccessor*() }

    /** Gets a header object that corresponds to this HTTP response. */
    DataFlow::MethodCallNode getAHeaderObject() {
      result.getTarget().getName() = "Header" and
      this.getANode() = result.getReceiver()
    }
  }

  private class HeaderWriteCall extends Http::HeaderWrite::Range, DataFlow::MethodCallNode {
    HeaderWriteCall() {
      this.getTarget().hasQualifiedName("net/http", "Header", "Add") or
      this.getTarget().hasQualifiedName("net/http", "Header", "Set")
    }

    override DataFlow::Node getName() { result = this.getArgument(0) }

    override DataFlow::Node getValue() { result = this.getArgument(1) }

    override Http::ResponseWriter getResponseWriter() {
      // find `v` in
      // ```
      // header := v.Header()
      // header.Add(...)
      // ```
      result.(StdlibResponseWriter).getAHeaderObject().getASuccessor*() = this.getReceiver()
    }
  }

  private class MapWrite extends Http::HeaderWrite::Range, DataFlow::Node {
    DataFlow::Node index;
    DataFlow::Node rhs;

    MapWrite() {
      this.getType().hasQualifiedName("net/http", "Header") and
      any(Write write).writesElement(this, index, rhs)
    }

    override DataFlow::Node getName() { result = index }

    override DataFlow::Node getValue() { result = rhs }

    override Http::ResponseWriter getResponseWriter() {
      // find `v` in
      // ```
      // header := v.Header()
      // header[...] = ...
      // ```
      result.(StdlibResponseWriter).getAHeaderObject().getASuccessor*() = this
    }
  }

  private class ResponseWriteHeaderCall extends Http::HeaderWrite::Range, DataFlow::MethodCallNode {
    ResponseWriteHeaderCall() {
      this.getTarget().implements("net/http", "ResponseWriter", "WriteHeader")
    }

    override string getHeaderName() { result = "status" }

    override DataFlow::Node getName() { none() }

    override DataFlow::Node getValue() { result = this.getArgument(0) }

    override Http::ResponseWriter getResponseWriter() { result.getANode() = this.getReceiver() }
  }

  private class ResponseErrorCall extends Http::HeaderWrite::Range, DataFlow::CallNode {
    ResponseErrorCall() { this.getTarget().hasQualifiedName("net/http", "Error") }

    override string getHeaderName() { result = "status" }

    override DataFlow::Node getName() { none() }

    override DataFlow::Node getValue() { result = this.getArgument(2) }

    override Http::ResponseWriter getResponseWriter() { result.getANode() = this.getArgument(0) }
  }

  private class RequestBody extends Http::RequestBody::Range, DataFlow::ExprNode {
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

  private DataFlow::Node getSummaryInputOrOutputNode(
    DataFlow::CallNode call, SummaryComponentStack stack
  ) {
    exists(int n | result = call.getSyntacticArgument(n) |
      if result = call.getImplicitVarargsArgument(_)
      then
        exists(
          int lastParamIndex, SummaryComponentStack varArgsSliceArgument,
          SummaryComponent arrayContentSC, DataFlow::ArrayContent arrayContent
        |
          lastParamIndex = call.getCall().getCalleeType().getNumParameter() - 1 and
          varArgsSliceArgument = SummaryComponentStack::argument(lastParamIndex) and
          arrayContentSC = SummaryComponent::content(arrayContent.asContentSet()) and
          stack = SummaryComponentStack::push(arrayContentSC, varArgsSliceArgument)
        )
      else stack = SummaryComponentStack::argument(n)
    )
    or
    stack = SummaryComponentStack::argument(-1) and
    result = call.getReceiver()
  }

  private class ResponseBody extends Http::ResponseBody::Range {
    DataFlow::Node responseWriter;

    ResponseBody() {
      exists(DataFlow::CallNode call |
        // A direct call to ResponseWriter.Write, conveying taint from the argument to the receiver
        call.getTarget().(Method).implements("net/http", "ResponseWriter", "Write") and
        this = call.getArgument(0) and
        responseWriter = call.(DataFlow::MethodCallNode).getReceiver()
      )
      or
      exists(TaintTracking::FunctionModel model |
        // A modeled function conveying taint from some input to the response writer,
        // e.g. `io.Copy(responseWriter, someTaintedReader)`
        this = model.getACall().getASyntacticArgument() and
        model.taintStep(this, responseWriter) and
        responseWriter.getType().implements("net/http", "ResponseWriter")
      )
      or
      exists(
        SummarizedCallableImpl callable, DataFlow::CallNode call, SummaryComponentStack input,
        SummaryComponentStack output
      |
        this = call.getASyntacticArgument() and
        callable = call.getACalleeIncludingExternals() and
        callable.propagatesFlow(input, output, _, _)
      |
        // A modeled function conveying taint from some input to the response writer,
        // e.g. `io.Copy(responseWriter, someTaintedReader)`
        // NB. SummarizedCallables do not implement a direct call-site-crossing flow step; instead
        // they are implemented by a function body with internal dataflow nodes, so we mimic the
        // one-step style for the particular case of taint propagation direct from an argument or receiver
        // to another argument, receiver or return value, matching the behavior for a `TaintTracking::FunctionModel`.
        this = getSummaryInputOrOutputNode(call, input) and
        responseWriter.(DataFlow::PostUpdateNode).getPreUpdateNode() =
          getSummaryInputOrOutputNode(call, output) and
        responseWriter.getType().implements("net/http", "ResponseWriter")
      )
    }

    override Http::ResponseWriter getResponseWriter() { result.getANode() = responseWriter }
  }

  /** A call to a function in the `net/http` package that performs an HTTP request to a URL. */
  private class RequestCall extends Http::ClientRequest::Range, DataFlow::CallNode {
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

  /** A call to the Client.Do function in the `net/http` package. */
  private class ClientDo extends Http::ClientRequest::Range, DataFlow::MethodCallNode {
    ClientDo() { this.getTarget().hasQualifiedName("net/http", "Client", "Do") }

    override DataFlow::Node getUrl() {
      // A URL passed to `NewRequest`, whose result is passed to this `Do` call
      exists(DataFlow::CallNode call | call.getTarget().hasQualifiedName("net/http", "NewRequest") |
        this.getArgument(0) = call.getResult(0).getASuccessor*() and
        result = call.getArgument(1)
      )
      or
      // A URL passed to `NewRequestWithContext`, whose result is passed to this `Do` call
      exists(DataFlow::CallNode call |
        call.getTarget().hasQualifiedName("net/http", "NewRequestWithContext")
      |
        this.getArgument(0) = call.getResult(0).getASuccessor*() and
        result = call.getArgument(2)
      )
      or
      // A URL assigned to a request that is passed to this `Do` call
      exists(Write w, Field f |
        f.hasQualifiedName("net/http", "Request", "URL") and
        w.writesField(this.getArgument(0).getAPredecessor*(), f, result)
      )
    }
  }

  /** A call to the `Transport.RoundTrip` function in the `net/http` package. */
  private class TransportRoundTrip extends Http::ClientRequest::Range, DataFlow::MethodCallNode {
    TransportRoundTrip() { this.getTarget().hasQualifiedName("net/http", "Transport", "RoundTrip") }

    override DataFlow::Node getUrl() {
      // A URL passed to `NewRequest`, whose result is passed to this `RoundTrip` call
      exists(DataFlow::CallNode call | call.getTarget().hasQualifiedName("net/http", "NewRequest") |
        this.getArgument(0) = call.getResult(0).getASuccessor*() and
        result = call.getArgument(1)
      )
      or
      // A URL passed to `NewRequestWithContext`, whose result is passed to this `RoundTrip` call
      exists(DataFlow::CallNode call |
        call.getTarget().hasQualifiedName("net/http", "NewRequestWithContext")
      |
        this.getArgument(0) = call.getResult(0).getASuccessor*() and
        result = call.getArgument(2)
      )
      or
      // A URL assigned to a request that is passed to this `RoundTrip` call
      exists(Write w, Field f |
        f.hasQualifiedName("net/http", "Request", "URL") and
        w.writesField(this.getArgument(0).getAPredecessor*(), f, result)
      )
    }
  }

  /** Fields and methods of `net/http.Request` that are not generally exploitable in an open-redirect attack. */
  private class RedirectUnexploitableRequestFields extends Http::Redirect::UnexploitableSource {
    RedirectUnexploitableRequestFields() {
      exists(Field f, string fieldName |
        f.hasQualifiedName("net/http", "Request", fieldName) and
        this = f.getARead()
      |
        fieldName = ["Body", "GetBody", "PostForm", "MultipartForm", "Header", "Trailer"]
      )
      or
      exists(Method m, string methName |
        m.hasQualifiedName("net/http", "Request", methName) and
        this = m.getACall().getResult(0)
      |
        methName = ["Cookie", "Cookies", "MultipartReader", "PostFormValue", "Referer", "UserAgent"]
      )
    }
  }

  private class Handler extends Http::RequestHandler::Range {
    DataFlow::CallNode handlerReg;

    Handler() {
      exists(Function regFn | regFn = handlerReg.getTarget() |
        regFn.hasQualifiedName("net/http", ["Handle", "HandleFunc"]) or
        regFn.(Method).hasQualifiedName("net/http", "ServeMux", ["Handle", "HandleFunc"])
      ) and
      this = handlerReg.getArgument(1)
    }

    override predicate guardedBy(DataFlow::Node check) { check = handlerReg.getArgument(0) }
  }

  /**
   * DEPRECATED: Use `FileSystemAccess::Range` instead.
   *
   * The File system access sinks
   */
  deprecated class HttpServeFile extends FileSystemAccess::Range, DataFlow::CallNode {
    HttpServeFile() {
      exists(Function f |
        f.hasQualifiedName("net/http", "ServeFile") and
        this = f.getACall()
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(2) }
  }
}
