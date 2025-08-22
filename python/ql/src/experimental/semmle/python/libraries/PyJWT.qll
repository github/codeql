private import python
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs
private import experimental.semmle.python.frameworks.JWT

private module PyJwt {
  /** Gets a reference to `jwt.encode` */
  private API::Node pyjwtEncode() { result = API::moduleImport("jwt").getMember("encode") }

  /** Gets a reference to `jwt.decode` */
  private API::Node pyjwtDecode() { result = API::moduleImport("jwt").getMember("decode") }

  /**
   * Gets a call to `jwt.encode`.
   *
   * Given the following example:
   *
   * ```py
   * jwt.encode(token, "key", "HS256")
   * ```
   *
   * * `this` would be `jwt.encode(token, "key", "HS256")`.
   * * `getPayload()`'s result would be `token`.
   * * `getKey()`'s result would be `"key"`.
   * * `getAlgorithm()`'s result would be `"HS256"`.
   * * `getAlgorithmstring()`'s result would be `HS256`.
   */
  private class PyJwtEncodeCall extends DataFlow::CallCfgNode, JwtEncoding::Range {
    PyJwtEncodeCall() { this = pyjwtEncode().getACall() }

    override DataFlow::Node getPayload() {
      result in [this.getArg(0), this.getArgByName("payload")]
    }

    override DataFlow::Node getKey() { result in [this.getArg(1), this.getArgByName("key")] }

    override DataFlow::Node getAlgorithm() {
      result in [this.getArg(2), this.getArgByName("algorithm")]
    }

    override string getAlgorithmString() {
      exists(StringLiteral str |
        DataFlow::exprNode(str).(DataFlow::LocalSourceNode).flowsTo(this.getAlgorithm()) and
        result = str.getText()
      )
    }
  }

  /**
   * Gets a call to `jwt.decode`.
   *
   * Given the following example:
   *
   * ```py
   * jwt.decode(token, key, "HS256", options={"verify_signature": True})
   * ```
   *
   * * `this` would be `jwt.decode(token, key, options={"verify_signature": True})`.
   * * `getPayload()`'s result would be `token`.
   * * `getKey()`'s result would be `key`.
   * * `getAlgorithm()`'s result would be `"HS256"`.
   * * `getAlgorithmstring()`'s result would be `HS256`.
   * * `getOptions()`'s result would be `{"verify_signature": True}`.
   * * `verifiesSignature()` predicate would succeed.
   */
  private class PyJwtDecodeCall extends DataFlow::CallCfgNode, JwtDecoding::Range {
    PyJwtDecodeCall() { this = pyjwtDecode().getACall() }

    override DataFlow::Node getPayload() { result in [this.getArg(0), this.getArgByName("jwt")] }

    override DataFlow::Node getKey() { result in [this.getArg(1), this.getArgByName("key")] }

    override DataFlow::Node getAlgorithm() {
      result in [this.getArg(2), this.getArgByName("algorithms")]
    }

    override string getAlgorithmString() {
      exists(StringLiteral str |
        DataFlow::exprNode(str).(DataFlow::LocalSourceNode).flowsTo(this.getAlgorithm()) and
        result = str.getText()
      )
    }

    override DataFlow::Node getOptions() {
      result in [this.getArg(3), this.getArgByName("options")]
    }

    override predicate verifiesSignature() {
      not this.hasVerifySetToFalse() and
      not this.hasVerifySignatureSetToFalse()
    }

    predicate hasNoVerifyArgumentOrOptions() {
      not exists(this.getArgByName("verify")) and not exists(this.getOptions())
    }

    predicate hasVerifySetToFalse() { isFalse(this.getArgByName("verify")) }

    predicate hasVerifySignatureSetToFalse() {
      exists(KeyValuePair optionsDict, NameConstant falseName |
        falseName.getId() = "False" and
        optionsDict = this.getOptions().asExpr().(Dict).getItem(_) and
        optionsDict.getKey().(Str_).getS().matches("%verify%") and
        falseName = optionsDict.getValue()
      )
    }
  }
}
