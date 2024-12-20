/**
 * Provides modeling for the `Typhoeus` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow

/**
 * A call that makes an HTTP request using `Typhoeus`.
 * ```ruby
 * Typhoeus.get("http://example.com").body
 * ```
 */
class TyphoeusHttpRequest extends Http::Client::Request::Range, DataFlow::CallNode {
  API::Node requestNode;
  boolean directResponse;

  TyphoeusHttpRequest() {
    this = requestNode.asSource() and
    (
      directResponse = true and
      requestNode =
        API::getTopLevelMember("Typhoeus")
            .getReturn(["get", "head", "delete", "options", "post", "put", "patch"])
      or
      directResponse = false and
      requestNode = API::getTopLevelMember("Typhoeus").getMember("Request").getInstance()
    )
  }

  override DataFlow::Node getAUrlPart() { result = this.getArgument(0) }

  override DataFlow::Node getResponseBody() {
    directResponse = true and
    result = getBodyFromResponse(requestNode)
    or
    directResponse = false and
    result = getResponseBodyFromRequest(requestNode)
  }

  /** Gets the value that controls certificate validation, if any. */
  DataFlow::Node getCertificateValidationControllingValue() {
    result = this.getKeywordArgumentIncludeHashArgument("ssl_verifypeer")
  }

  cached
  override predicate disablesCertificateValidation(
    DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
  ) {
    TyphoeusDisablesCertificateValidationFlow::flow(argumentOrigin, disablingNode) and
    disablingNode = this.getCertificateValidationControllingValue()
  }

  override string getFramework() { result = "Typhoeus" }
}

/** A configuration to track values that can disable certificate validation for Typhoeus. */
private module TyphoeusDisablesCertificateValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().getExpr().(BooleanLiteral).isFalse() }

  predicate isSink(DataFlow::Node sink) {
    sink = any(TyphoeusHttpRequest req).getCertificateValidationControllingValue()
  }

  predicate observeDiffInformedIncrementalMode() {
    none() // Used for a library model
  }
}

private module TyphoeusDisablesCertificateValidationFlow =
  DataFlow::Global<TyphoeusDisablesCertificateValidationConfig>;

/** Gets the response body from the given `requestNode` representing a Typhoeus request */
bindingset[requestNode]
pragma[inline_late]
private DataFlow::Node getResponseBodyFromRequest(API::Node requestNode) {
  result =
    [
      getBodyFromResponse(getResponseFromRequest(requestNode)),
      requestNode.getMethod("on_body").getBlock().getParameter(0).asSource()
    ]
}

/** Gets the response from the given `requestNode` representing a Typhoeus request */
bindingset[requestNode]
pragma[inline_late]
private API::Node getResponseFromRequest(API::Node requestNode) {
  result =
    [
      requestNode.getReturn(["run", "response"]),
      requestNode
          // on_headers does not carry a response body
          .getMethod(["on_complete", "on_success", "on_failure", "on_progress"])
          .getBlock()
          .getParameter(0)
    ]
}

/** Gets the response body from the given `responseNode` representing a Typhoeus response */
bindingset[responseNode]
pragma[inline_late]
private DataFlow::Node getBodyFromResponse(API::Node responseNode) {
  result = responseNode.getAMethodCall(["body", "response_body"])
}
