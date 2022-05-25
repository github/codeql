/**
 * Provides modeling for the `RestClient` library.
 */

private import ruby
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow

/**
 * A call that makes an HTTP request using `RestClient`.
 * ```ruby
 * RestClient.get("http://example.com").body
 * RestClient::Resource.new("http://example.com").get.body
 * RestClient::Request.execute(url: "http://example.com").body
 * ```
 */
class RestClientHttpRequest extends HTTP::Client::Request::Range {
  DataFlow::CallNode requestUse;
  API::Node requestNode;
  API::Node connectionNode;

  RestClientHttpRequest() {
    requestUse = requestNode.getAnImmediateUse() and
    this = requestUse.asExpr().getExpr() and
    (
      connectionNode =
        [
          API::getTopLevelMember("RestClient"),
          API::getTopLevelMember("RestClient").getMember("Resource").getInstance()
        ] and
      requestNode =
        connectionNode.getReturn(["get", "head", "delete", "options", "post", "put", "patch"])
      or
      connectionNode = API::getTopLevelMember("RestClient").getMember("Request") and
      requestNode = connectionNode.getReturn("execute")
    )
  }

  override DataFlow::Node getAUrlPart() {
    result = requestUse.getKeywordArgument("url")
    or
    result = requestUse.getArgument(0) and
    // this rules out the alternative above
    not result.asExpr().getExpr() instanceof Pair
  }

  override DataFlow::Node getResponseBody() { result = requestNode.getAMethodCall("body") }

  override predicate disablesCertificateValidation(DataFlow::Node disablingNode) {
    // `RestClient::Resource::new` takes an options hash argument, and we're
    // looking for `{ verify_ssl: OpenSSL::SSL::VERIFY_NONE }`.
    exists(DataFlow::Node arg, int i |
      i > 0 and arg = connectionNode.getAUse().(DataFlow::CallNode).getArgument(i)
    |
      // Either passed as an individual key:value argument, e.g.:
      // RestClient::Resource.new(..., verify_ssl: OpenSSL::SSL::VERIFY_NONE)
      isVerifySslNonePair(arg.asExpr()) and
      disablingNode = arg
      or
      // Or as a single hash argument, e.g.:
      // RestClient::Resource.new(..., { verify_ssl: OpenSSL::SSL::VERIFY_NONE })
      exists(DataFlow::LocalSourceNode optionsNode, CfgNodes::ExprNodes::PairCfgNode p |
        p = optionsNode.asExpr().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair() and
        isVerifySslNonePair(p) and
        optionsNode.flowsTo(arg) and
        disablingNode.asExpr() = p
      )
    )
  }

  override string getFramework() { result = "RestClient" }
}

/** Holds if `p` is the pair `verify_ssl: OpenSSL::SSL::VERIFY_NONE`. */
private predicate isVerifySslNonePair(CfgNodes::ExprNodes::PairCfgNode p) {
  exists(DataFlow::Node key, DataFlow::Node value |
    key.asExpr() = p.getKey() and
    value.asExpr() = p.getValue() and
    isSslVerifyModeLiteral(key) and
    value = API::getTopLevelMember("OpenSSL").getMember("SSL").getMember("VERIFY_NONE").getAUse()
  )
}

/** Holds if `node` can represent the symbol literal `:verify_ssl`. */
private predicate isSslVerifyModeLiteral(DataFlow::Node node) {
  exists(DataFlow::LocalSourceNode literal |
    literal.asExpr().getExpr().getConstantValue().isStringlikeValue("verify_ssl") and
    literal.flowsTo(node)
  )
}
