private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.StandardLibrary

/**
 * A call that makes an HTTP request using `OpenURI` via `URI.open` or
 * `URI.parse(...).open`.
 *
 * ```ruby
 * URI.open("http://example.com").readlines
 * URI.parse("http://example.com").open.read
 * ```
 */
class OpenUriRequest extends HTTP::Client::Request::Range {
  API::Node requestNode;
  DataFlow::CallNode requestUse;

  OpenUriRequest() {
    requestNode =
      [API::getTopLevelMember("URI"), API::getTopLevelMember("URI").getReturn("parse")]
          .getReturn("open") and
    requestUse = requestNode.getAnImmediateUse() and
    this = requestUse.asExpr().getExpr()
  }

  override DataFlow::Node getURL() { result = requestUse.getArgument(0) }

  override DataFlow::Node getResponseBody() {
    result = requestNode.getAMethodCall(["read", "readlines"])
  }

  override predicate disablesCertificateValidation(DataFlow::Node disablingNode) {
    exists(DataFlow::Node arg |
      arg.asExpr().getExpr() = requestUse.asExpr().getExpr().(MethodCall).getArgument(_)
    |
      argumentDisablesValidation(arg, disablingNode)
    )
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
class OpenUriKernelOpenRequest extends HTTP::Client::Request::Range {
  DataFlow::CallNode requestUse;

  OpenUriKernelOpenRequest() {
    requestUse instanceof KernelMethodCall and
    this.getMethodName() = "open" and
    this = requestUse.asExpr().getExpr()
  }

  override DataFlow::Node getURL() { result = requestUse.getArgument(0) }

  override DataFlow::CallNode getResponseBody() {
    result.asExpr().getExpr().(MethodCall).getMethodName() in ["read", "readlines"] and
    requestUse.(DataFlow::LocalSourceNode).flowsTo(result.getReceiver())
  }

  override predicate disablesCertificateValidation(DataFlow::Node disablingNode) {
    exists(DataFlow::Node arg, int i |
      i > 0 and
      arg.asExpr().getExpr() = requestUse.asExpr().getExpr().(MethodCall).getArgument(i)
    |
      argumentDisablesValidation(arg, disablingNode)
    )
  }

  override string getFramework() { result = "OpenURI" }
}

/**
 * Holds if the argument `arg` is an options hash that disables certificate
 * validation, and `disablingNode` is the specific node representing the
 * `ssl_verify_mode: OpenSSL::SSL_VERIFY_NONE` pair.
 */
private predicate argumentDisablesValidation(DataFlow::Node arg, DataFlow::Node disablingNode) {
  // Either passed as an individual key:value argument, e.g.:
  // URI.open(..., ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
  isSslVerifyModeNonePair(arg.asExpr().getExpr()) and
  disablingNode = arg
  or
  // Or as a single hash argument, e.g.:
  // URI.open(..., { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, ... })
  exists(DataFlow::LocalSourceNode optionsNode, Pair p |
    p = optionsNode.asExpr().getExpr().(HashLiteral).getAKeyValuePair() and
    isSslVerifyModeNonePair(p) and
    optionsNode.flowsTo(arg) and
    disablingNode.asExpr().getExpr() = p
  )
}

/** Holds if `p` is the pair `ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE`. */
private predicate isSslVerifyModeNonePair(Pair p) {
  exists(DataFlow::Node key, DataFlow::Node value |
    key.asExpr().getExpr() = p.getKey() and value.asExpr().getExpr() = p.getValue()
  |
    isSslVerifyModeLiteral(key) and
    value = API::getTopLevelMember("OpenSSL").getMember("SSL").getMember("VERIFY_NONE").getAUse()
  )
}

/** Holds if `node` can represent the symbol literal `:ssl_verify_mode`. */
private predicate isSslVerifyModeLiteral(DataFlow::Node node) {
  exists(DataFlow::LocalSourceNode literal |
    literal.asExpr().getExpr().getConstantValue().isStringOrSymbol("ssl_verify_mode") and
    literal.flowsTo(node)
  )
}
