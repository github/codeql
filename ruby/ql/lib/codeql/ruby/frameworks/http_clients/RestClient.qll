/**
 * Provides modeling for the `RestClient` library.
 */

private import ruby
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.internal.DataFlowImplForLibraries as DataFlowImplForLibraries

/**
 * A call that makes an HTTP request using `RestClient`.
 * ```ruby
 * RestClient.get("http://example.com").body
 * RestClient::Resource.new("http://example.com").get.body
 * RestClient::Request.execute(url: "http://example.com").body
 * ```
 */
class RestClientHttpRequest extends HTTP::Client::Request::Range, DataFlow::CallNode {
  API::Node requestNode;
  API::Node connectionNode;

  RestClientHttpRequest() {
    this = requestNode.asSource() and
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
    result = this.getKeywordArgument("url")
    or
    result = this.getArgument(0) and
    // this rules out the alternative above
    not result.asExpr().getExpr() instanceof Pair
  }

  override DataFlow::Node getResponseBody() { result = requestNode.getAMethodCall("body") }

  /** Gets the value that controls certificate validation, if any. */
  DataFlow::Node getCertificateValidationControllingValue() {
    // `RestClient::Resource::new` takes an options hash argument, and we're
    // looking for `{ verify_ssl: OpenSSL::SSL::VERIFY_NONE }`.
    exists(DataFlow::CallNode newCall | newCall = connectionNode.getAValueReachableFromSource() |
      result = newCall.getKeywordArgument("verify_ssl")
      or
      // using a hashliteral
      exists(
        DataFlow::LocalSourceNode optionsNode, CfgNodes::ExprNodes::PairCfgNode p,
        DataFlow::Node key
      |
        // can't flow to argument 0, since that's the URL
        optionsNode.flowsTo(newCall.getArgument(any(int i | i > 0))) and
        p = optionsNode.asExpr().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair() and
        key.asExpr() = p.getKey() and
        key.getALocalSource().asExpr().getExpr().getConstantValue().isStringlikeValue("verify_ssl") and
        result.asExpr() = p.getValue()
      )
    )
  }

  override predicate disablesCertificateValidation(
    DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
  ) {
    any(RestClientDisablesCertificateValidationConfiguration config)
        .hasFlow(argumentOrigin, disablingNode) and
    disablingNode = this.getCertificateValidationControllingValue()
  }

  override string getFramework() { result = "RestClient" }
}

/** A configuration to track values that can disable certificate validation for RestClient. */
private class RestClientDisablesCertificateValidationConfiguration extends DataFlowImplForLibraries::Configuration {
  RestClientDisablesCertificateValidationConfiguration() {
    this = "RestClientDisablesCertificateValidationConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    source = API::getTopLevelMember("OpenSSL").getMember("SSL").getMember("VERIFY_NONE").asSource()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(RestClientHttpRequest req).getCertificateValidationControllingValue()
  }
}
