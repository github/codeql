/**
 * Provides modeling for the `Typhoeus` library.
 */

private import ruby
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.internal.DataFlowImplForLibraries as DataFlowImplForLibraries

/**
 * A call that makes an HTTP request using `Typhoeus`.
 * ```ruby
 * Typhoeus.get("http://example.com").body
 * ```
 */
class TyphoeusHttpRequest extends HTTP::Client::Request::Range, DataFlow::CallNode {
  API::Node requestNode;

  TyphoeusHttpRequest() {
    this = requestNode.asSource() and
    requestNode =
      API::getTopLevelMember("Typhoeus")
          .getReturn(["get", "head", "delete", "options", "post", "put", "patch"])
  }

  override DataFlow::Node getAUrlPart() { result = this.getArgument(0) }

  override DataFlow::Node getResponseBody() { result = requestNode.getAMethodCall("body") }

  /** Gets the value that controls certificate validation, if any. */
  DataFlow::Node getCertificateValidationControllingValue() {
    result = this.getKeywordArgument("ssl_verifypeer")
    or
    // using a hashliteral
    exists(
      DataFlow::LocalSourceNode optionsNode, CfgNodes::ExprNodes::PairCfgNode p,
      DataFlow::Node key
    |
      // can't flow to argument 0, since that's the URL
      optionsNode.flowsTo(this.getArgument(any(int i | i > 0))) and
      p = optionsNode.asExpr().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair() and
      key.asExpr() = p.getKey() and
      key.getALocalSource().asExpr().getExpr().getConstantValue().isStringlikeValue("ssl_verifypeer") and
      result.asExpr() = p.getValue()
    )
  }

  override predicate disablesCertificateValidation(
    DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
  ) {
    any(TyphoeusDisablesCertificateValidationConfiguration config)
        .hasFlow(argumentOrigin, disablingNode) and
    disablingNode = this.getCertificateValidationControllingValue()
  }

  override string getFramework() { result = "Typhoeus" }
}

/** A configuration to track values that can disable certificate validation for Typhoeus. */
private class TyphoeusDisablesCertificateValidationConfiguration extends DataFlowImplForLibraries::Configuration {
  TyphoeusDisablesCertificateValidationConfiguration() {
    this = "TyphoeusDisablesCertificateValidationConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().getExpr().(BooleanLiteral).isFalse()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(TyphoeusHttpRequest req).getCertificateValidationControllingValue()
  }
}
