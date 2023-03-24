/**
 * Provides modeling for the `Typhoeus` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.internal.DataFlowImplForHttpClientLibraries as DataFlowImplForHttpClientLibraries

/**
 * A call that makes an HTTP request using `Typhoeus`.
 * ```ruby
 * Typhoeus.get("http://example.com").body
 * ```
 */
class TyphoeusHttpRequest extends Http::Client::Request::Range, DataFlow::CallNode {
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
    result = this.getKeywordArgumentIncludeHashArgument("ssl_verifypeer")
  }

  cached
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
private class TyphoeusDisablesCertificateValidationConfiguration extends DataFlowImplForHttpClientLibraries::Configuration
{
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
