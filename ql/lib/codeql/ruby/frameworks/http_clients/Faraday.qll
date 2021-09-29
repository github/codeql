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
class FaradayHttpRequest extends HTTP::Client::Request::Range {
  DataFlow::Node requestUse;
  API::Node requestNode;
  API::Node connectionNode;

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
    this = requestUse.asExpr().getExpr()
  }

  override DataFlow::Node getResponseBody() { result = requestNode.getAMethodCall("body") }

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
      isSslOptionsPairDisablingValidation(arg.asExpr().getExpr()) and
      disablingNode = arg
      or
      // Or as a single hash argument, e.g.:
      // Faraday.new(..., { ssl: {...} })
      exists(DataFlow::LocalSourceNode optionsNode, Pair p |
        p = optionsNode.asExpr().getExpr().(HashLiteral).getAKeyValuePair() and
        isSslOptionsPairDisablingValidation(p) and
        optionsNode.flowsTo(arg) and
        disablingNode.asExpr().getExpr() = p
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
private predicate isSslOptionsPairDisablingValidation(Pair p) {
  exists(DataFlow::Node key, DataFlow::Node value |
    key.asExpr().getExpr() = p.getKey() and value.asExpr().getExpr() = p.getValue()
  |
    exists(DataFlow::LocalSourceNode literal |
      literal.asExpr().getExpr().(SymbolLiteral).getValueText() = "ssl" and
      literal.flowsTo(key)
    ) and
    (isHashWithVerifyFalse(value) or isHashWithVerifyModeNone(value))
  )
}

/**
 * Holds if `node` represents a hash containing the key-value pair
 * `verify: false`.
 */
private predicate isHashWithVerifyFalse(DataFlow::Node node) {
  exists(DataFlow::LocalSourceNode hash |
    isVerifyFalsePair(hash.asExpr().getExpr().(HashLiteral).getAKeyValuePair()) and
    hash.flowsTo(node)
  )
}

/**
 * Holds if `node` represents a hash containing the key-value pair
 * `verify_mode: OpenSSL::SSL::VERIFY_NONE`.
 */
private predicate isHashWithVerifyModeNone(DataFlow::Node node) {
  exists(DataFlow::LocalSourceNode hash |
    isVerifyModeNonePair(hash.asExpr().getExpr().(HashLiteral).getAKeyValuePair()) and
    hash.flowsTo(node)
  )
}

/**
 * Holds if the pair `p` has the key `:verify_mode` and the value
 * `OpenSSL::SSL::VERIFY_NONE`.
 */
private predicate isVerifyModeNonePair(Pair p) {
  exists(DataFlow::Node key, DataFlow::Node value |
    key.asExpr().getExpr() = p.getKey() and value.asExpr().getExpr() = p.getValue()
  |
    exists(DataFlow::LocalSourceNode literal |
      literal.asExpr().getExpr().(SymbolLiteral).getValueText() = "verify_mode" and
      literal.flowsTo(key)
    ) and
    value = API::getTopLevelMember("OpenSSL").getMember("SSL").getMember("VERIFY_NONE").getAUse()
  )
}

/**
 * Holds if the pair `p` has the key `:verify` and the value `false`.
 */
private predicate isVerifyFalsePair(Pair p) {
  exists(DataFlow::Node key, DataFlow::Node value |
    key.asExpr().getExpr() = p.getKey() and value.asExpr().getExpr() = p.getValue()
  |
    exists(DataFlow::LocalSourceNode literal |
      literal.asExpr().getExpr().(SymbolLiteral).getValueText() = "verify" and
      literal.flowsTo(key)
    ) and
    isFalsey(value)
  )
}

/** Holds if `node` contains `0` or `false`. */
private predicate isFalsey(DataFlow::Node node) {
  exists(DataFlow::LocalSourceNode literal |
    (
      literal.asExpr().getExpr().(BooleanLiteral).isFalse() or
      literal.asExpr().getExpr().(IntegerLiteral).getValue() = 0
    ) and
    literal.flowsTo(node)
  )
}
