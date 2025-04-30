/**
 * Provides modeling for the `Excon` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow

/**
 * A call that makes an HTTP request using `Excon`.
 * ```ruby
 * # one-off request
 * Excon.get("http://example.com").body
 *
 * # connection re-use
 * connection = Excon.new("http://example.com")
 * connection.get(path: "/").body
 * connection.request(method: :get, path: "/")
 * ```
 *
 * TODO: pipelining, streaming responses
 * https://github.com/excon/excon/blob/master/README.md
 */
class ExconHttpRequest extends Http::Client::Request::Range, DataFlow::CallNode {
  API::Node requestNode;
  API::Node connectionNode;
  DataFlow::Node connectionUse;

  ExconHttpRequest() {
    this = requestNode.asSource() and
    connectionUse = connectionNode.asSource() and
    connectionNode =
      [
        // one-off requests
        API::getTopLevelMember("Excon"),
        // connection re-use
        API::getTopLevelMember("Excon").getInstance(),
        API::getTopLevelMember("Excon").getMember("Connection").getInstance()
      ] and
    requestNode =
      connectionNode
          .getReturn([
              // Excon#request exists but Excon.request doesn't.
              // This shouldn't be a problem - in real code the latter would raise NoMethodError anyway.
              "get", "head", "delete", "options", "post", "put", "patch", "trace", "request"
            ])
  }

  override DataFlow::Node getResponseBody() { result = requestNode.getAMethodCall("body") }

  override DataFlow::Node getAUrlPart() {
    // For one-off requests, the URL is in the first argument of the request method call.
    // For connection re-use, the URL is split between the first argument of the `new` call
    // and the `path` keyword argument of the request method call.
    result = this.getArgument(0) and not result.asExpr().getExpr() instanceof Pair
    or
    result = this.getKeywordArgument("path")
    or
    result = connectionUse.(DataFlow::CallNode).getArgument(0)
  }

  /** Gets the value that controls certificate validation, if any. */
  DataFlow::Node getCertificateValidationControllingValue() {
    result =
      connectionUse.(DataFlow::CallNode).getKeywordArgumentIncludeHashArgument("ssl_verify_peer")
  }

  cached
  override predicate disablesCertificateValidation(
    DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
  ) {
    ExconDisablesCertificateValidationFlow::flow(argumentOrigin, disablingNode) and
    disablingNode = this.getCertificateValidationControllingValue()
    or
    // We set `Excon.defaults[:ssl_verify_peer]` or `Excon.ssl_verify_peer` = false`
    // before the request, and no `ssl_verify_peer: true` in the explicit options hash
    // for the request call.
    exists(DataFlow::CallNode disableCall, BooleanLiteral value |
      // Excon.defaults[:ssl_verify_peer]
      disableCall = API::getTopLevelMember("Excon").getReturn("defaults").getAMethodCall("[]=") and
      disableCall
          .getArgument(0)
          .getALocalSource()
          .asExpr()
          .getConstantValue()
          .isStringlikeValue("ssl_verify_peer") and
      disablingNode = disableCall.getArgument(1) and
      argumentOrigin = disablingNode.getALocalSource() and
      value = argumentOrigin.asExpr().getExpr()
      or
      // Excon.ssl_verify_peer
      disableCall = API::getTopLevelMember("Excon").getAMethodCall("ssl_verify_peer=") and
      disablingNode = disableCall.getArgument(0) and
      argumentOrigin = disablingNode.getALocalSource() and
      value = argumentOrigin.asExpr().getExpr()
    |
      value.getValue() = false and
      disableCall.asExpr().getASuccessor+() = this.asExpr() and
      // no `ssl_verify_peer: true` in the request call.
      not this.getCertificateValidationControllingValue()
          .getALocalSource()
          .asExpr()
          .getExpr()
          .(BooleanLiteral)
          .getValue() = true
    )
  }

  override string getFramework() { result = "Excon" }
}

/** A configuration to track values that can disable certificate validation for Excon. */
private module ExconDisablesCertificateValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().getExpr().(BooleanLiteral).isFalse() }

  predicate isSink(DataFlow::Node sink) {
    sink = any(ExconHttpRequest req).getCertificateValidationControllingValue()
  }

  predicate observeDiffInformedIncrementalMode() {
    none() // Used for a library model
  }
}

private module ExconDisablesCertificateValidationFlow =
  DataFlow::Global<ExconDisablesCertificateValidationConfig>;
