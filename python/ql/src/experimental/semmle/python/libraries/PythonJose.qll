private import python
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs
private import experimental.semmle.python.frameworks.JWT

private module PythonJose {
  /** Gets a reference to `jwt` */
  private API::Node joseJwt() { result = API::moduleImport("jose").getMember("jwt") }

  /** Gets a reference to `jwt.encode` */
  private API::Node joseJwtEncode() { result = joseJwt().getMember("encode") }

  /** Gets a reference to `jwt.decode` */
  private API::Node joseJwtDecode() { result = joseJwt().getMember("decode") }

  /**
   * Gets a call to `jwt.encode`.
   *
   * Given the following example:
   *
   * ```py
   * jwt.encode(token, key="key", algorithm="HS256")
   * ```
   *
   * * `this` would be `jwt.encode(token, key="key", algorithm="HS256")`.
   * * `getPayload()`'s result would be `token`.
   * * `getKey()`'s result would be `"key"`.
   * * `getAlgorithm()`'s result would be `"HS256"`.
   * * `getAlgorithmstring()`'s result would be `HS256`.
   */
  private class JoseJwtEncodeCall extends DataFlow::CallCfgNode, JwtEncoding::Range {
    JoseJwtEncodeCall() { this = joseJwtEncode().getACall() }

    override DataFlow::Node getPayload() { result = this.getArg(0) }

    override DataFlow::Node getKey() { result in [this.getArg(1), this.getArgByName("key")] }

    override DataFlow::Node getAlgorithm() {
      result in [this.getArg(2), this.getArgByName("algorithm")]
    }

    override string getAlgorithmString() {
      exists(StrConst str |
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
   * jwt.decode(token, "key", "HS256")
   * ```
   *
   * * `this` would be `jwt.decode(token, "key", "HS256")`.
   * * `getPayload()`'s result would be `token`.
   * * `getKey()`'s result would be `"key"`.
   * * `getAlgorithm()`'s result would be `"HS256"`.
   * * `getAlgorithmstring()`'s result would be `HS256`.
   * * `getOptions()`'s result would be none.
   * * `verifiesSignature()` predicate would succeed.
   */
  private class JoseJwtDecodeCall extends DataFlow::CallCfgNode, JwtDecoding::Range {
    JoseJwtDecodeCall() { this = joseJwtDecode().getACall() }

    override DataFlow::Node getPayload() { result = this.getArg(0) }

    override DataFlow::Node getKey() { result in [this.getArg(1), this.getArgByName("key")] }

    override DataFlow::Node getAlgorithm() {
      result in [this.getArg(2), this.getArgByName("algorithms")]
    }

    override string getAlgorithmString() {
      exists(StrConst str |
        DataFlow::exprNode(str).(DataFlow::LocalSourceNode).flowsTo(this.getAlgorithm()) and
        result = str.getText()
      )
    }

    override DataFlow::Node getOptions() {
      result in [this.getArg(3), this.getArgByName("options")]
    }

    override predicate verifiesSignature() {
      // jwt.decode(token, key, options={"verify_signature": False})
      not this.hasVerifySignatureSetToFalse()
    }

    predicate hasNoOptions() { not exists(this.getOptions()) }

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
