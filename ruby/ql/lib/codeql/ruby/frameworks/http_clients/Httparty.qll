private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs

/**
 * A call that makes an HTTP request using `HTTParty`.
 * ```ruby
 * # one-off request - returns the response body
 * HTTParty.get("http://example.com")
 *
 * # TODO: module inclusion
 * class MyClass
 *  include HTTParty
 *  base_uri "http://example.com"
 * end
 *
 * MyClass.new("http://example.com")
 * ```
 */
class HttpartyRequest extends HTTP::Client::Request::Range {
  API::Node requestNode;
  DataFlow::CallNode requestUse;

  HttpartyRequest() {
    requestUse = requestNode.getAnImmediateUse() and
    requestNode =
      API::getTopLevelMember("HTTParty")
          .getReturn(["get", "head", "delete", "options", "post", "put", "patch"]) and
    this = requestUse.asExpr().getExpr()
  }

  override DataFlow::Node getURL() { result = requestUse.getArgument(0) }

  override DataFlow::Node getResponseBody() {
    // If HTTParty can recognise the response type, it will parse and return it
    // directly from the request call. Otherwise, it will return a `HTTParty::Response`
    // object that has a `#body` method.
    // So if there's a call to `#body` on the response, treat that as the response body.
    exists(DataFlow::Node r | r = requestNode.getAMethodCall("body") | result = r)
    or
    // Otherwise, treat the response as the response body.
    not exists(requestNode.getAMethodCall("body")) and
    result = requestUse
  }

  override predicate disablesCertificateValidation(DataFlow::Node disablingNode) {
    // The various request methods take an options hash as their second
    // argument, and we're looking for `{ verify: false }` or
    // `{ verify_peer: false }`.
    exists(DataFlow::Node arg, int i |
      i > 0 and arg.asExpr().getExpr() = requestUse.asExpr().getExpr().(MethodCall).getArgument(i)
    |
      // Either passed as an individual key:value argument, e.g.:
      // HTTParty.get(..., verify: false)
      isVerifyFalsePair(arg.asExpr().getExpr()) and
      disablingNode = arg
      or
      // Or as a single hash argument, e.g.:
      // HTTParty.get(..., { verify: false, ... })
      exists(DataFlow::LocalSourceNode optionsNode, Pair p |
        p = optionsNode.asExpr().getExpr().(HashLiteral).getAKeyValuePair() and
        isVerifyFalsePair(p) and
        optionsNode.flowsTo(arg) and
        disablingNode.asExpr().getExpr() = p
      )
    )
  }

  override string getFramework() { result = "HTTParty" }
}

/** Holds if `node` represents the symbol literal `verify` or `verify_peer`. */
private predicate isVerifyLiteral(DataFlow::Node node) {
  exists(DataFlow::LocalSourceNode literal |
    literal.asExpr().getExpr().getConstantValue().isStringOrSymbol(["verify", "verify_peer"]) and
    literal.flowsTo(node)
  )
}

/** Holds if `node` can contain the Boolean value `false`. */
private predicate isFalse(DataFlow::Node node) {
  exists(DataFlow::LocalSourceNode literal |
    literal.asExpr().getExpr().(BooleanLiteral).isFalse() and
    literal.flowsTo(node)
  )
}

/**
 * Holds if `p` is the pair `verify: false` or `verify_peer: false`.
 */
private predicate isVerifyFalsePair(Pair p) {
  exists(DataFlow::Node key, DataFlow::Node value |
    key.asExpr().getExpr() = p.getKey() and value.asExpr().getExpr() = p.getValue()
  |
    isVerifyLiteral(key) and
    isFalse(value)
  )
}
