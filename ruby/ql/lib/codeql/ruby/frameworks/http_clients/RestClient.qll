/**
 * Provides modeling for the `RestClient` library.
 */

private import codeql.ruby.AST
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
class RestClientHttpRequest extends Http::Client::Request::Range, DataFlow::CallNode {
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
    exists(DataFlow::CallNode newCall | newCall = connectionNode.getAValueReachableFromSource() |
      result = newCall.getKeywordArgumentIncludeHashArgument("verify_ssl")
    )
  }

  cached
  override predicate disablesCertificateValidation(
    DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
  ) {
    RestClientDisablesCertificateValidationFlow::flow(argumentOrigin, disablingNode) and
    disablingNode = this.getCertificateValidationControllingValue()
  }

  override string getFramework() { result = "RestClient" }
}

/** A configuration to track values that can disable certificate validation for RestClient. */
private module RestClientDisablesCertificateValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = API::getTopLevelMember("OpenSSL").getMember("SSL").getMember("VERIFY_NONE").asSource()
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(RestClientHttpRequest req).getCertificateValidationControllingValue()
  }

  predicate observeDiffInformedIncrementalMode() {
    none() // Used for a library model
  }
}

private module RestClientDisablesCertificateValidationFlow =
  DataFlow::Global<RestClientDisablesCertificateValidationConfig>;
