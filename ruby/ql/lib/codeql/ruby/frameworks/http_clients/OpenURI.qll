/**
 * Provides modeling for the `OpenURI` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.frameworks.Core

/**
 * A call that makes an HTTP request using `OpenURI` via `URI.open` or
 * `URI.parse(...).open`.
 *
 * ```ruby
 * URI.open("http://example.com").readlines
 * URI.parse("http://example.com").open.read
 * ```
 */
class OpenUriRequest extends Http::Client::Request::Range, DataFlow::CallNode {
  API::Node requestNode;

  OpenUriRequest() {
    requestNode =
      [
        [API::getTopLevelMember("URI"), API::getTopLevelMember("URI").getReturn("parse")]
            .getReturn("open"), API::getTopLevelMember("OpenURI").getReturn("open_uri")
      ] and
    this = requestNode.asSource()
  }

  override DataFlow::Node getAUrlPart() { result = this.getArgument(0) }

  override DataFlow::Node getResponseBody() {
    result = requestNode.getAMethodCall(["read", "readlines"])
  }

  /** Gets the value that controls certificate validation, if any. */
  DataFlow::Node getCertificateValidationControllingValue() {
    result = this.getKeywordArgumentIncludeHashArgument("ssl_verify_mode")
  }

  cached
  override predicate disablesCertificateValidation(
    DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
  ) {
    OpenUriDisablesCertificateValidationFlow::flow(argumentOrigin, disablingNode) and
    disablingNode = this.getCertificateValidationControllingValue()
  }

  override string getFramework() { result = "OpenURI" }
}

/**
 * A call that makes an HTTP request using `OpenURI` and its `Kernel.open`
 * interface.
 *
 * ```ruby
 * Kernel.open("http://example.com").read
 * ```
 */
class OpenUriKernelOpenRequest extends Http::Client::Request::Range, DataFlow::CallNode instanceof KernelMethodCall
{
  OpenUriKernelOpenRequest() { this.getMethodName() = "open" }

  override DataFlow::Node getAUrlPart() { result = this.getArgument(0) }

  override DataFlow::CallNode getResponseBody() {
    result.asExpr().getExpr().(MethodCall).getMethodName() in ["read", "readlines"] and
    this.(DataFlow::LocalSourceNode).flowsTo(result.getReceiver())
  }

  /** Gets the value that controls certificate validation, if any. */
  DataFlow::Node getCertificateValidationControllingValue() {
    result = this.getKeywordArgument("ssl_verify_mode")
    or
    // using a hashliteral
    exists(
      DataFlow::LocalSourceNode optionsNode, CfgNodes::ExprNodes::PairCfgNode p, DataFlow::Node key
    |
      // can't flow to argument 0, since that's the URL
      optionsNode.flowsTo(this.getArgument(any(int i | i > 0))) and
      p = optionsNode.asExpr().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair() and
      key.asExpr() = p.getKey() and
      key.getALocalSource().asExpr().getConstantValue().isStringlikeValue("ssl_verify_mode") and
      result.asExpr() = p.getValue()
    )
  }

  cached
  override predicate disablesCertificateValidation(
    DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
  ) {
    OpenUriDisablesCertificateValidationFlow::flow(argumentOrigin, disablingNode) and
    disablingNode = this.getCertificateValidationControllingValue()
  }

  override string getFramework() { result = "OpenURI" }
}

/** A configuration to track values that can disable certificate validation for OpenURI. */
private module OpenUriDisablesCertificateValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = API::getTopLevelMember("OpenSSL").getMember("SSL").getMember("VERIFY_NONE").asSource()
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(OpenUriRequest req).getCertificateValidationControllingValue()
    or
    sink = any(OpenUriKernelOpenRequest req).getCertificateValidationControllingValue()
  }

  predicate observeDiffInformedIncrementalMode() {
    none() // Used for a library model
  }
}

private module OpenUriDisablesCertificateValidationFlow =
  DataFlow::Global<OpenUriDisablesCertificateValidationConfig>;
