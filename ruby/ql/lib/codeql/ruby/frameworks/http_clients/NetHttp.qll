/**
 * Provides modeling for the `Net::HTTP` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.internal.DataFlowPublic
private import codeql.ruby.DataFlow

/**
 * A `Net::HTTP` call which initiates an HTTP request.
 * ```ruby
 * Net::HTTP.get("http://example.com/")
 * Net::HTTP.post("http://example.com/", "some_data")
 * req = Net::HTTP.new("example.com")
 * response = req.get("/")
 * ```
 */
class NetHttpRequest extends HTTP::Client::Request::Range {
  private DataFlow::CallNode request;
  private DataFlow::Node responseBody;

  NetHttpRequest() {
    exists(API::Node requestNode, string method |
      request = requestNode.getAnImmediateUse() and
      this = request.asExpr().getExpr()
    |
      // Net::HTTP.get(...)
      method = "get" and
      requestNode = API::getTopLevelMember("Net").getMember("HTTP").getReturn(method) and
      responseBody = request
      or
      // Net::HTTP.post(...).body
      method in ["post", "post_form"] and
      requestNode = API::getTopLevelMember("Net").getMember("HTTP").getReturn(method) and
      responseBody = requestNode.getAMethodCall(["body", "read_body", "entity"])
      or
      // Net::HTTP.new(..).get(..).body
      method in [
          "get", "get2", "request_get", "head", "head2", "request_head", "delete", "put", "patch",
          "post", "post2", "request_post", "request"
        ] and
      requestNode = API::getTopLevelMember("Net").getMember("HTTP").getInstance().getReturn(method) and
      responseBody = requestNode.getAMethodCall(["body", "read_body", "entity"])
    )
  }

  /**
   * Gets the node representing the URL of the request.
   * Currently unused, but may be useful in future, e.g. to filter out certain requests.
   */
  override DataFlow::Node getAUrlPart() { result = request.getArgument(0) }

  override DataFlow::Node getResponseBody() { result = responseBody }

  override predicate disablesCertificateValidation(DataFlow::Node disablingNode) {
    // A Net::HTTP request bypasses certificate validation if we see a setter
    // call like this:
    //   foo.verify_mode = OpenSSL::SSL::VERIFY_NONE
    // and then the receiver of that call flows to the receiver in the request:
    //   foo.request(...)
    exists(DataFlow::CallNode setter |
      disablingNode =
        API::getTopLevelMember("OpenSSL").getMember("SSL").getMember("VERIFY_NONE").getAUse() and
      setter.asExpr().getExpr().(SetterMethodCall).getMethodName() = "verify_mode=" and
      disablingNode = setter.getArgument(0) and
      localFlow(setter.getReceiver(), request.getReceiver())
    )
  }

  override string getFramework() { result = "Net::HTTP" }
}
