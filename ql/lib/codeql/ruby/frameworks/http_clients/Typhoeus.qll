private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs

/**
 * A call that makes an HTTP request using `Typhoeus`.
 * ```ruby
 * Typhoeus.get("http://example.com").body
 * ```
 */
class TyphoeusHTTPRequest extends HTTP::Client::Request::Range {
  DataFlow::Node request;
  DataFlow::CallNode responseBody;

  TyphoeusHTTPRequest() {
    exists(API::Node requestNode | request = requestNode.getAnImmediateUse() |
      requestNode =
        API::getTopLevelMember("Typhoeus")
            .getReturn(["get", "head", "delete", "options", "post", "put", "patch"]) and
      responseBody = requestNode.getAMethodCall("body") and
      this = request.asExpr().getExpr()
    )
  }

  override DataFlow::Node getResponseBody() { result = responseBody }

  override string getFramework() { result = "Typhoeus" }
}
