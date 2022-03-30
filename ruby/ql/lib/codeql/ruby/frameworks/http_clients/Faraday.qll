/**
 * Provides modeling for the `Faraday` library.
 */

private import ruby
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow

/**
 * A call that makes an HTTP request using `Faraday`.
 * ```ruby
 * # one-off request
 * Faraday.get("http://example.com").body
 *
 * # connection re-use
 * connection = Faraday.new("http://example.com")
 * connection.get("/").body
 *
 * connection = Faraday.new(url: "http://example.com")
 * connection.get("/").body
 * ```
 */
class FaradayHttpRequest extends HTTP::Client::Request::Range {
  API::Node requestNode;
  API::Node connectionNode;
  DataFlow::Node connectionUse;
  DataFlow::CallNode requestUse;

  FaradayHttpRequest() {
    connectionNode =
      [
        // one-off requests
        API::getTopLevelMember("Faraday"),
        // connection re-use
        API::getTopLevelMember("Faraday").getInstance()
      ] and
    requestNode =
      connectionNode.getReturn(["get", "head", "delete", "post", "put", "patch", "trace"]) and
    requestUse = requestNode.getAnImmediateUse() and
    connectionUse = connectionNode.getAnImmediateUse() and
    this = requestUse.asExpr().getExpr()
  }

  override DataFlow::Node getResponseBody() { result = requestNode.getAMethodCall("body") }

  override DataFlow::Node getAUrlPart() {
    result = requestUse.getArgument(0) or
    result = connectionUse.(DataFlow::CallNode).getArgument(0) or
    result = connectionUse.(DataFlow::CallNode).getKeywordArgument("url")
  }

  override predicate disablesCertificateValidation(DataFlow::Node disablingNode) {
    // `Faraday::new` takes an options hash as its second argument, and we're
    // looking for
    // `{ ssl: { verify: false } }`
    // or
    // `{ ssl: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }`
    exists(DataFlow::Node arg, int i |
      i > 0 and arg = connectionNode.getAUse().(DataFlow::CallNode).getArgument(i)
    |
      // Either passed as an individual key:value argument, e.g.:
      // Faraday.new(..., ssl: {...})
      isSslOptionsPairDisablingValidation(arg.asExpr()) and
      disablingNode = arg
      or
      // Or as a single hash argument, e.g.:
      // Faraday.new(..., { ssl: {...} })
      exists(DataFlow::LocalSourceNode optionsNode, CfgNodes::ExprNodes::PairCfgNode p |
        p = optionsNode.asExpr().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair() and
        isSslOptionsPairDisablingValidation(p) and
        optionsNode.flowsTo(arg) and
        disablingNode.asExpr() = p
      )
    )
  }

  override string getFramework() { result = "Faraday" }
}

/**
 * Holds if the pair `p` contains the key `:ssl` for which the value is a hash
 * containing either `verify: false` or
 * `verify_mode: OpenSSL::SSL::VERIFY_NONE`.
 */
private predicate isSslOptionsPairDisablingValidation(CfgNodes::ExprNodes::PairCfgNode p) {
  exists(DataFlow::Node key, DataFlow::Node value |
    key.asExpr() = p.getKey() and
    value.asExpr() = p.getValue() and
    isSymbolLiteral(key, "ssl") and
    (isHashWithVerifyFalse(value) or isHashWithVerifyModeNone(value))
  )
}

/** Holds if `node` represents the symbol literal with the given `valueText`. */
private predicate isSymbolLiteral(DataFlow::Node node, string valueText) {
  exists(DataFlow::LocalSourceNode literal |
    literal.asExpr().getExpr().getConstantValue().isStringlikeValue(valueText) and
    literal.flowsTo(node)
  )
}

/**
 * Holds if `node` represents a hash containing the key-value pair
 * `verify: false`.
 */
private predicate isHashWithVerifyFalse(DataFlow::Node node) {
  exists(DataFlow::LocalSourceNode hash |
    isVerifyFalsePair(hash.asExpr().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair()) and
    hash.flowsTo(node)
  )
}

/**
 * Holds if `node` represents a hash containing the key-value pair
 * `verify_mode: OpenSSL::SSL::VERIFY_NONE`.
 */
private predicate isHashWithVerifyModeNone(DataFlow::Node node) {
  exists(DataFlow::LocalSourceNode hash |
    isVerifyModeNonePair(hash.asExpr().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair()) and
    hash.flowsTo(node)
  )
}

/**
 * Holds if the pair `p` has the key `:verify_mode` and the value
 * `OpenSSL::SSL::VERIFY_NONE`.
 */
private predicate isVerifyModeNonePair(CfgNodes::ExprNodes::PairCfgNode p) {
  exists(DataFlow::Node key, DataFlow::Node value |
    key.asExpr() = p.getKey() and
    value.asExpr() = p.getValue() and
    isSymbolLiteral(key, "verify_mode") and
    value = API::getTopLevelMember("OpenSSL").getMember("SSL").getMember("VERIFY_NONE").getAUse()
  )
}

/**
 * Holds if the pair `p` has the key `:verify` and the value `false`.
 */
private predicate isVerifyFalsePair(CfgNodes::ExprNodes::PairCfgNode p) {
  exists(DataFlow::Node key, DataFlow::Node value |
    key.asExpr() = p.getKey() and
    value.asExpr() = p.getValue() and
    isSymbolLiteral(key, "verify") and
    isFalse(value)
  )
}

/** Holds if `node` can contain the Boolean value `false`. */
private predicate isFalse(DataFlow::Node node) {
  exists(DataFlow::LocalSourceNode literal |
    literal.asExpr().getExpr().(BooleanLiteral).isFalse() and
    literal.flowsTo(node)
  )
}
