/**
 * Provides modeling for the `HTTParty` library.
 */

private import ruby
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.internal.DataFlowImplForLibraries as DataFlowImplForLibraries

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
class HttpartyRequest extends HTTP::Client::Request::Range, DataFlow::CallNode {
  API::Node requestNode;

  HttpartyRequest() {
    this = requestNode.asSource() and
    requestNode =
      API::getTopLevelMember("HTTParty")
          .getReturn(["get", "head", "delete", "options", "post", "put", "patch"])
  }

  override DataFlow::Node getAUrlPart() { result = this.getArgument(0) }

  override DataFlow::Node getResponseBody() {
    // If HTTParty can recognise the response type, it will parse and return it
    // directly from the request call. Otherwise, it will return a `HTTParty::Response`
    // object that has a `#body` method.
    // So if there's a call to `#body` on the response, treat that as the response body.
    exists(DataFlow::Node r | r = requestNode.getAMethodCall("body") | result = r)
    or
    // Otherwise, treat the response as the response body.
    not exists(requestNode.getAMethodCall("body")) and
    result = this
  }

  /** Gets the value that controls certificate validation, if any. */
  DataFlow::Node getCertificateValidationControllingValue() {
    result = this.getKeywordArgument(["verify", "verify_peer"])
    or
    // using a hashliteral
    exists(
      DataFlow::LocalSourceNode optionsNode, CfgNodes::ExprNodes::PairCfgNode p, DataFlow::Node key
    |
      // can't flow to argument 0, since that's the URL
      optionsNode.flowsTo(this.getArgument(any(int i | i > 0))) and
      p = optionsNode.asExpr().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair() and
      key.asExpr() = p.getKey() and
      key.getALocalSource()
          .asExpr()
          .getExpr()
          .getConstantValue()
          .isStringlikeValue(["verify", "verify_peer"]) and
      result.asExpr() = p.getValue()
    )
  }

  override predicate disablesCertificateValidation(
    DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
  ) {
    any(HttpartyDisablesCertificateValidationConfiguration config)
        .hasFlow(argumentOrigin, disablingNode) and
    disablingNode = this.getCertificateValidationControllingValue()
  }

  override string getFramework() { result = "HTTParty" }
}

/** A configuration to track values that can disable certificate validation for Httparty. */
private class HttpartyDisablesCertificateValidationConfiguration extends DataFlowImplForLibraries::Configuration {
  HttpartyDisablesCertificateValidationConfiguration() {
    this = "HttpartyDisablesCertificateValidationConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().getExpr().(BooleanLiteral).isFalse()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(HttpartyRequest req).getCertificateValidationControllingValue()
  }
}
