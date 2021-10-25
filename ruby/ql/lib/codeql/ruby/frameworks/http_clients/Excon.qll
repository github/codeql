private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs

/**
 * A call that makes an HTTP request using `Excon`.
 * ```ruby
 * # one-off request
 * Excon.get("http://example.com").body
 *
 * # connection re-use
 * connection = Excon.new("http://example.com")
 * connection.get(path: "/").body
 * connection.request(method: :get, path: "/")
 * ```
 *
 * TODO: pipelining, streaming responses
 * https://github.com/excon/excon/blob/master/README.md
 */
class ExconHTTPRequest extends HTTP::Client::Request::Range {
  DataFlow::Node request;
  DataFlow::CallNode responseBody;

  ExconHTTPRequest() {
    exists(API::Node requestNode | request = requestNode.getAnImmediateUse() |
      requestNode =
        [
          // one-off requests
          API::getTopLevelMember("Excon"),
          // connection re-use
          API::getTopLevelMember("Excon").getInstance()
        ]
            .getReturn([
                // Excon#request exists but Excon.request doesn't.
                // This shouldn't be a problem - in real code the latter would raise NoMethodError anyway.
                "get", "head", "delete", "options", "post", "put", "patch", "trace", "request"
              ]) and
      responseBody = requestNode.getAMethodCall("body") and
      this = request.asExpr().getExpr()
    )
  }

  override DataFlow::Node getResponseBody() { result = responseBody }

  override string getFramework() { result = "Excon" }
}
