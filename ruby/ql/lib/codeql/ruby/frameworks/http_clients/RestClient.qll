private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs

/**
 * A call that makes an HTTP request using `RestClient`.
 * ```ruby
 * RestClient.get("http://example.com").body
 * ```
 */
class RestClientHTTPRequest extends HTTP::Client::Request::Range {
  DataFlow::Node request;
  DataFlow::CallNode responseBody;

  RestClientHTTPRequest() {
    exists(API::Node requestNode |
      requestNode =
        API::getTopLevelMember("RestClient")
            .getReturn(["get", "head", "delete", "options", "post", "put", "patch"]) and
      request = requestNode.getAnImmediateUse() and
      responseBody = requestNode.getAMethodCall("body") and
      this = request.asExpr().getExpr()
    )
  }

  override DataFlow::Node getResponseBody() { result = responseBody }

  override string getFramework() { result = "RestClient" }
}
