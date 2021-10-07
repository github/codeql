private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs

/**
 * A call that makes an HTTP request using `HTTPClient`.
 * ```ruby
 * HTTPClient.get("http://example.com").body
 * HTTPClient.get_content("http://example.com")
 * ```
 */
class HttpClientRequest extends HTTP::Client::Request::Range {
  DataFlow::Node request;
  DataFlow::CallNode responseBody;

  HttpClientRequest() {
    exists(API::Node requestNode, string method |
      request = requestNode.getAnImmediateUse() and
      method in [
          "get", "head", "delete", "options", "post", "put", "trace", "get_content", "post_content"
        ]
    |
      requestNode = API::getTopLevelMember("HTTPClient").getReturn(method) and
      (
        // The `get_content` and `post_content` methods return the response body as a string.
        // The other methods return a `HTTPClient::Message` object which has various methods
        // that return the response body.
        method in ["get_content", "post_content"] and responseBody = request
        or
        not method in ["get_content", "put_content"] and
        responseBody = requestNode.getAMethodCall(["body", "http_body", "content", "dump"])
      ) and
      this = request.asExpr().getExpr()
    )
  }

  override DataFlow::Node getResponseBody() { result = responseBody }

  override string getFramework() { result = "HTTPClient" }
}
