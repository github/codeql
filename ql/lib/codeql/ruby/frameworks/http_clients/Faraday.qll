private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs

/**
 * A call that makes an HTTP request using `Faraday`.
 * ```ruby
 * # one-off request
 * Faraday.get("http://example.com").body
 *
 * # connection re-use
 * connection = Faraday.new("http://example.com")
 * connection.get("/").body
 * ```
 */
class FaradayHTTPRequest extends HTTP::Client::Request::Range {
  DataFlow::Node request;
  DataFlow::CallNode responseBody;

  FaradayHTTPRequest() {
    exists(API::Node requestNode |
      requestNode =
        [
          // one-off requests
          API::getTopLevelMember("Faraday"),
          // connection re-use
          API::getTopLevelMember("Faraday").getInstance()
        ].getReturn(["get", "head", "delete", "post", "put", "patch", "trace"]) and
      responseBody = requestNode.getAMethodCall("body") and
      request = requestNode.getAnImmediateUse() and
      this = request.asExpr().getExpr()
    )
  }

  override DataFlow::Node getResponseBody() { result = responseBody }

  override string getFramework() { result = "Faraday" }
}
