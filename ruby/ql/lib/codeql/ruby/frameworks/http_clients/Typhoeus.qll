private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs

/**
 * A call that makes an HTTP request using `Typhoeus`.
 * ```ruby
 * Typhoeus.get("http://example.com").body
 * ```
 */
class TyphoeusHttpRequest extends HTTP::Client::Request::Range {
  DataFlow::CallNode requestUse;
  API::Node requestNode;

  TyphoeusHttpRequest() {
    requestUse = requestNode.getAnImmediateUse() and
    requestNode =
      API::getTopLevelMember("Typhoeus")
          .getReturn(["get", "head", "delete", "options", "post", "put", "patch"]) and
    this = requestUse.asExpr().getExpr()
  }

  override DataFlow::Node getURL() { result = requestUse.getArgument(0) }

  override DataFlow::Node getResponseBody() { result = requestNode.getAMethodCall("body") }

  override predicate disablesCertificateValidation(DataFlow::Node disablingNode) {
    // Check for `ssl_verifypeer: false` in the options hash.
    exists(DataFlow::Node arg, int i |
      i > 0 and arg.asExpr().getExpr() = requestUse.asExpr().getExpr().(MethodCall).getArgument(i)
    |
      // Either passed as an individual key:value argument, e.g.:
      // Typhoeus.get(..., ssl_verifypeer: false)
      isSslVerifyPeerFalsePair(arg.asExpr().getExpr()) and
      disablingNode = arg
      or
      // Or as a single hash argument, e.g.:
      // Typhoeus.get(..., { ssl_verifypeer: false, ... })
      exists(DataFlow::LocalSourceNode optionsNode, Pair p |
        p = optionsNode.asExpr().getExpr().(HashLiteral).getAKeyValuePair() and
        isSslVerifyPeerFalsePair(p) and
        optionsNode.flowsTo(arg) and
        disablingNode.asExpr().getExpr() = p
      )
    )
  }

  override string getFramework() { result = "Typhoeus" }
}

/** Holds if `p` is the pair `ssl_verifypeer: false`. */
private predicate isSslVerifyPeerFalsePair(Pair p) {
  exists(DataFlow::Node key, DataFlow::Node value |
    key.asExpr().getExpr() = p.getKey() and
    value.asExpr().getExpr() = p.getValue()
  |
    isSslVerifyPeerLiteral(key) and
    isFalse(value)
  )
}

/** Holds if `node` represents the symbol literal `verify` or `verify_peer`. */
private predicate isSslVerifyPeerLiteral(DataFlow::Node node) {
  exists(DataFlow::LocalSourceNode literal |
    literal.asExpr().getExpr().getConstantValue().isStringOrSymbol("ssl_verifypeer") and
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
