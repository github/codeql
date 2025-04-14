/**
 * Provides modeling for the `Faraday` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow

/**
 * A call that makes an HTTP request using `Faraday`.
 * ```ruby
 * # one-off request
 * Faraday.get("http://example.com").body
 *
 * # connection re-use
 * connection = Faraday.new("http://example.com")
 * connection.get("/").body
 *
 * connection = Faraday.new(url: "http://example.com")
 * connection.get("/").body
 * ```
 */
class FaradayHttpRequest extends Http::Client::Request::Range, DataFlow::CallNode {
  API::Node requestNode;
  API::Node connectionNode;
  DataFlow::Node connectionUse;

  FaradayHttpRequest() {
    connectionNode =
      [
        // one-off requests
        API::getTopLevelMember("Faraday"),
        // connection re-use
        API::getTopLevelMember("Faraday").getInstance(),
        // connection re-use with Faraday::Connection.new instantiation
        API::getTopLevelMember("Faraday").getMember("Connection").getInstance()
      ] and
    requestNode =
      connectionNode
          .getReturn(["get", "head", "delete", "post", "put", "patch", "trace", "run_request"]) and
    this = requestNode.asSource() and
    connectionUse = connectionNode.asSource()
  }

  override DataFlow::Node getResponseBody() { result = requestNode.getAMethodCall("body") }

  override DataFlow::Node getAUrlPart() {
    result = this.getArgument(0) or
    result = connectionUse.(DataFlow::CallNode).getArgument(0) or
    result = connectionUse.(DataFlow::CallNode).getKeywordArgument("url")
  }

  /** Gets the value that controls certificate validation, if any, with argument name `name`. */
  DataFlow::Node getCertificateValidationControllingValue(string argName) {
    // `Faraday::new` takes an options hash as its second argument, and we're
    // looking for
    // `{ ssl: { verify: false } }`
    // or
    // `{ ssl: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }`
    argName in ["verify", "verify_mode"] and
    exists(DataFlow::Node sslValue, DataFlow::CallNode newCall |
      newCall = connectionNode.getAValueReachableFromSource() and
      sslValue = newCall.getKeywordArgumentIncludeHashArgument("ssl")
    |
      exists(CfgNodes::ExprNodes::PairCfgNode p, DataFlow::Node key |
        p = sslValue.asExpr().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair() and
        key.asExpr() = p.getKey() and
        key.getALocalSource().asExpr().getConstantValue().isStringlikeValue(argName) and
        result.asExpr() = p.getValue()
      )
    )
  }

  cached
  override predicate disablesCertificateValidation(
    DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
  ) {
    FaradayDisablesCertificateValidationFlow::flow(argumentOrigin, disablingNode) and
    disablingNode = this.getCertificateValidationControllingValue(_)
  }

  override string getFramework() { result = "Faraday" }
}

/** A configuration to track values that can disable certificate validation for Faraday. */
private module FaradayDisablesCertificateValidationConfig implements DataFlow::StateConfigSig {
  class FlowState = string;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source.asExpr().getExpr().(BooleanLiteral).isFalse() and
    state = "verify"
    or
    source = API::getTopLevelMember("OpenSSL").getMember("SSL").getMember("VERIFY_NONE").asSource() and
    state = "verify_mode"
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink = any(FaradayHttpRequest req).getCertificateValidationControllingValue(state)
  }

  predicate observeDiffInformedIncrementalMode() {
    none() // Used for a library model
  }
}

private module FaradayDisablesCertificateValidationFlow =
  DataFlow::GlobalWithState<FaradayDisablesCertificateValidationConfig>;
