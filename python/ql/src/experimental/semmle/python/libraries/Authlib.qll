private import python
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs
private import experimental.semmle.python.frameworks.JWT

private module Authlib {
  /** Gets a reference to `authlib.jose.(jwt|JsonWebToken)` */
  private API::Node authlibJwt() {
    result in [
        API::moduleImport("authlib").getMember("jose").getMember("jwt"),
        API::moduleImport("authlib").getMember("jose").getMember("JsonWebToken").getReturn()
      ]
  }

  /** Gets a reference to `jwt.encode` */
  private API::Node authlibJwtEncode() { result = authlibJwt().getMember("encode") }

  /** Gets a reference to `jwt.decode` */
  private API::Node authlibJwtDecode() { result = authlibJwt().getMember("decode") }

  /**
   * Gets a call to `authlib.jose.(jwt|JsonWebToken).encode`.
   *
   * Given the following example:
   *
   * ```py
   * jwt.encode({"alg": "HS256"}, token, "key")
   * ```
   *
   * * `this` would be `jwt.encode({"alg": "HS256"}, token, "key")`.
   * * `getPayload()`'s result would be `token`.
   * * `getKey()`'s result would be `"key"`.
   * * `getAlgorithm()`'s result would be `"HS256"`.
   * * `getAlgorithmstring()`'s result would be `HS256`.
   */
  private class AuthlibJwtEncodeCall extends DataFlow::CallCfgNode, JwtEncoding::Range {
    AuthlibJwtEncodeCall() { this = authlibJwtEncode().getACall() }

    override DataFlow::Node getPayload() { result = this.getArg(1) }

    override DataFlow::Node getKey() { result = this.getArg(2) }

    override DataFlow::Node getAlgorithm() {
      exists(KeyValuePair headerDict |
        headerDict = this.getArg(0).asExpr().(Dict).getItem(_) and
        headerDict.getKey().(Str_).getS() = "alg" and
        result.asExpr() = headerDict.getValue()
      )
    }

    override string getAlgorithmString() {
      exists(StringLiteral str |
        DataFlow::exprNode(str).(DataFlow::LocalSourceNode).flowsTo(this.getAlgorithm()) and
        result = str.getText()
      )
    }
  }

  /**
   * Gets a call to `authlib.jose.(jwt|JsonWebToken).decode`
   *
   * Given the following example:
   *
   * ```py
   * jwt.decode(token, key)
   * ```
   *
   * * `this` would be `jwt.decode(token, key)`.
   * * `getPayload()`'s result would be `token`.
   * * `getKey()`'s result would be `key`.
   */
  private class AuthlibJwtDecodeCall extends DataFlow::CallCfgNode, JwtDecoding::Range {
    AuthlibJwtDecodeCall() { this = authlibJwtDecode().getACall() }

    override DataFlow::Node getPayload() { result = this.getArg(0) }

    override DataFlow::Node getKey() { result = this.getArg(1) }

    override DataFlow::Node getAlgorithm() { none() }

    override string getAlgorithmString() { none() }

    override DataFlow::Node getOptions() { none() }

    override predicate verifiesSignature() { any() }
  }
}
