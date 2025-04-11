/**
 * Models the `Request` and `Response` objects from the Web standards.
 */

private import javascript

/** Treats `Response` as an entry point for API graphs. */
private class ResponseEntryPoint extends API::EntryPoint {
  ResponseEntryPoint() { this = "global.Response" }

  override DataFlow::SourceNode getASource() { result = DataFlow::globalVarRef("Response") }
}

/** Treats `Headers` as an entry point for API graphs. */
private class HeadersEntryPoint extends API::EntryPoint {
  HeadersEntryPoint() { this = "global.Headers" }

  override DataFlow::SourceNode getASource() { result = DataFlow::globalVarRef("Headers") }
}

/**
 * A call to the `Response` constructor.
 */
private class ResponseCall extends API::InvokeNode {
  ResponseCall() { this = any(ResponseEntryPoint e).getANode().getAnInstantiation() }
}

/**
 * A call to the `Headers` constructor.
 */
private class HeadersCall extends API::InvokeNode {
  HeadersCall() { this = any(HeadersEntryPoint e).getANode().getAnInstantiation() }
}

/**
 * The `headers` in `new Response(body, { headers })`
 */
private class ResponseArgumentHeaders extends Http::HeaderDefinition {
  private ResponseCall response;
  private API::Node headerNode;

  ResponseArgumentHeaders() {
    headerNode = response.getParameter(1).getMember("headers") and
    this = headerNode.asSink()
  }

  ResponseCall getResponse() { result = response }

  /**
   * Gets a call to `new Headers()` that is passed as the headers to this call.
   */
  private HeadersCall getHeadersCall() { headerNode.refersTo(result.getReturn()) }

  /**
   * Gets an object whose properties are interpreted as headers, such as `{'content-type': 'foo'}`.
   */
  private API::Node getAPlainHeaderObject() {
    // new Response(body, {...})
    result = headerNode
    or
    // new Response(body, new Headers({...}))
    result = this.getHeadersCall().getParameter(0)
  }

  private API::Node getHeaderNode(string headerName) {
    exists(string prop |
      result = this.getAPlainHeaderObject().getMember(prop) and
      headerName = prop.toLowerCase()
    )
    or
    exists(API::CallNode append |
      append = this.getHeadersCall().getReturn().getMember(["append", "set"]).getACall() and
      headerName = append.getArgument(0).getStringValue().toLowerCase() and
      result = append.getParameter(1)
    )
  }

  override predicate defines(string headerName, string headerValue) {
    this.getHeaderNode(headerName).getAValueReachingSink().getStringValue() = headerValue
  }

  override string getAHeaderName() { exists(this.getHeaderNode(result)) }

  override Http::RouteHandler getRouteHandler() { none() }
}

/**
 * Data passed as the body in `new Response(body, ...)`.
 */
private class ResponseSink extends Http::ResponseSendArgument {
  private ResponseCall response;

  ResponseSink() { this = response.getArgument(0) }

  override Http::RouteHandler getRouteHandler() { none() }

  override ResponseArgumentHeaders getAnAssociatedHeaderDefinition() {
    result.getResponse() = response
  }
}
