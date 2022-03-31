/**
 * Provides modeling for the `Excon` library.
 */

private import ruby
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow

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
class ExconHttpRequest extends HTTP::Client::Request::Range {
  DataFlow::CallNode requestUse;
  API::Node requestNode;
  API::Node connectionNode;
  DataFlow::Node connectionUse;

  ExconHttpRequest() {
    requestUse = requestNode.getAnImmediateUse() and
    connectionUse = connectionNode.getAnImmediateUse() and
    connectionNode =
      [
        // one-off requests
        API::getTopLevelMember("Excon"),
        // connection re-use
        API::getTopLevelMember("Excon").getInstance(),
        API::getTopLevelMember("Excon").getMember("Connection").getInstance()
      ] and
    requestNode =
      connectionNode
          .getReturn([
              // Excon#request exists but Excon.request doesn't.
              // This shouldn't be a problem - in real code the latter would raise NoMethodError anyway.
              "get", "head", "delete", "options", "post", "put", "patch", "trace", "request"
            ]) and
    this = requestUse.asExpr().getExpr()
  }

  override DataFlow::Node getResponseBody() { result = requestNode.getAMethodCall("body") }

  override DataFlow::Node getAUrlPart() {
    // For one-off requests, the URL is in the first argument of the request method call.
    // For connection re-use, the URL is split between the first argument of the `new` call
    // and the `path` keyword argument of the request method call.
    result = requestUse.getArgument(0) and not result.asExpr().getExpr() instanceof Pair
    or
    result = requestUse.getKeywordArgument("path")
    or
    result = connectionUse.(DataFlow::CallNode).getArgument(0)
  }

  override predicate disablesCertificateValidation(DataFlow::Node disablingNode) {
    // Check for `ssl_verify_peer: false` in the options hash.
    exists(DataFlow::Node arg, int i |
      i > 0 and arg = connectionNode.getAUse().(DataFlow::CallNode).getArgument(i)
    |
      argSetsVerifyPeer(arg, false, disablingNode)
    )
    or
    // Or we see a call to `Excon.defaults[:ssl_verify_peer] = false` before the
    // request, and no `ssl_verify_peer: true` in the explicit options hash for
    // the request call.
    exists(DataFlow::CallNode disableCall |
      setsDefaultVerification(disableCall, false) and
      disableCall.asExpr().getASuccessor+() = requestUse.asExpr() and
      disablingNode = disableCall and
      not exists(DataFlow::Node arg, int i |
        i > 0 and arg = connectionNode.getAUse().(DataFlow::CallNode).getArgument(i)
      |
        argSetsVerifyPeer(arg, true, _)
      )
    )
  }

  override string getFramework() { result = "Excon" }
}

/**
 * Holds if `arg` represents an options hash that contains the key
 * `:ssl_verify_peer` with `value`, where `kvNode` is the data-flow node for
 * this key-value pair.
 */
predicate argSetsVerifyPeer(DataFlow::Node arg, boolean value, DataFlow::Node kvNode) {
  // Either passed as an individual key:value argument, e.g.:
  // Excon.get(..., ssl_verify_peer: false)
  isSslVerifyPeerPair(arg.asExpr(), value) and
  kvNode = arg
  or
  // Or as a single hash argument, e.g.:
  // Excon.get(..., { ssl_verify_peer: false, ... })
  exists(DataFlow::LocalSourceNode optionsNode, CfgNodes::ExprNodes::PairCfgNode p |
    p = optionsNode.asExpr().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair() and
    isSslVerifyPeerPair(p, value) and
    optionsNode.flowsTo(arg) and
    kvNode.asExpr() = p
  )
}

/**
 * Holds if `callNode` sets `Excon.defaults[:ssl_verify_peer]` or
 * `Excon.ssl_verify_peer` to `value`.
 */
private predicate setsDefaultVerification(DataFlow::CallNode callNode, boolean value) {
  callNode = API::getTopLevelMember("Excon").getReturn("defaults").getAMethodCall("[]=") and
  isSslVerifyPeerLiteral(callNode.getArgument(0)) and
  hasBooleanValue(callNode.getArgument(1), value)
  or
  callNode = API::getTopLevelMember("Excon").getAMethodCall("ssl_verify_peer=") and
  hasBooleanValue(callNode.getArgument(0), value)
}

private predicate isSslVerifyPeerLiteral(DataFlow::Node node) {
  exists(DataFlow::LocalSourceNode literal |
    literal.asExpr().getExpr().getConstantValue().isStringlikeValue("ssl_verify_peer") and
    literal.flowsTo(node)
  )
}

/** Holds if `node` can contain `value`. */
private predicate hasBooleanValue(DataFlow::Node node, boolean value) {
  exists(DataFlow::LocalSourceNode literal |
    literal.asExpr().getExpr().(BooleanLiteral).getValue() = value and
    literal.flowsTo(node)
  )
}

/** Holds if `p` is the pair `ssl_verify_peer: <value>`. */
private predicate isSslVerifyPeerPair(CfgNodes::ExprNodes::PairCfgNode p, boolean value) {
  exists(DataFlow::Node key, DataFlow::Node valueNode |
    key.asExpr() = p.getKey() and
    valueNode.asExpr() = p.getValue() and
    isSslVerifyPeerLiteral(key) and
    hasBooleanValue(valueNode, value)
  )
}
