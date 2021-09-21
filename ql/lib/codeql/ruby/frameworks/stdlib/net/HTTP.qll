private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.internal.DataFlowPublic

/**
 * A shortcut for uses of Net::HTTP
 */
private API::Node netHTTP() { result = API::getTopLevelMember("Net").getMember("HTTP") }

/**
 * A call that returns the response body of a `Net::HTTP` request as a String.
 * ```ruby
 * req = Net::HTTP.new("example.com")
 * response = req.get("/")
 * body = response.body
 * ```
 */
private class NetHTTPRequestResponseBody extends CallNode {
  DataFlow::CallNode requestCall;

  NetHTTPRequestResponseBody() {
    exists(string methodName, API::Node requestCallNode |
      requestCall = requestCallNode.getAnImmediateUse()
    |
      // Net::HTTP.get(...)
      methodName = "get" and
      requestCallNode = netHTTP().getReturn(methodName) and
      this = requestCall
      or
      // Net::HTTP.post(...).body
      methodName in ["post", "post_form"] and
      requestCallNode = netHTTP().getReturn(methodName) and
      this = requestCallNode.getAMethodCall(["body", "read_body", "entity"])
      or
      // Net::HTTP.new(..).get(..).body
      methodName in [
          "get", "get2", "request_get", "head", "head2", "request_head", "delete", "put", "patch",
          "post", "post2", "request_post", "request"
        ] and
      requestCallNode = netHTTP().getInstance().getReturn(methodName) and
      this = requestCallNode.getAMethodCall(["body", "read_body", "entity"])
    )
  }

  /**
   * Gets the node representing the method call that initiates the request.
   * This may be different from the node which returns the response body.
   */
  DataFlow::Node getRequestCall() { result = requestCall }

  /**
   * Gets the node representing the URL of the request.
   * Currently unused, but may be useful in future, e.g. to filter out certain requests.
   */
  DataFlow::Node getURLArgument() { result = requestCall.getArgument(0) }
}

/**
 * A `Net::HTTP` call which initiates an HTTP request.
 */
class NetHTTPRequest extends HTTP::Client::Request::Range {
  private NetHTTPRequestResponseBody responseBody;

  NetHTTPRequest() { this = responseBody.getRequestCall().asExpr().getExpr() }

  override DataFlow::Node getResponseBody() { result = responseBody }

  override string getFramework() { result = "Net::HTTP" }
}
