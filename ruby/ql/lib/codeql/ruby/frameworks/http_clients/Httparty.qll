/**
 * Provides modeling for the `HTTParty` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow

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
class HttpartyRequest extends Http::Client::Request::Range, DataFlow::CallNode {
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
    result = this.getKeywordArgumentIncludeHashArgument(["verify", "verify_peer"])
  }

  cached
  override predicate disablesCertificateValidation(
    DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
  ) {
    HttpartyDisablesCertificateValidationFlow::flow(argumentOrigin, disablingNode) and
    disablingNode = this.getCertificateValidationControllingValue()
  }

  override string getFramework() { result = "HTTParty" }
}

/** A configuration to track values that can disable certificate validation for Httparty. */
private module HttpartyDisablesCertificateValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().getExpr().(BooleanLiteral).isFalse() }

  predicate isSink(DataFlow::Node sink) {
    sink = any(HttpartyRequest req).getCertificateValidationControllingValue()
  }

  predicate observeDiffInformedIncrementalMode() {
    none() // Used for a library model
  }
}

private module HttpartyDisablesCertificateValidationFlow =
  DataFlow::Global<HttpartyDisablesCertificateValidationConfig>;
