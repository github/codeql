private import python
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs
private import experimental.semmle.python.frameworks.JWT

private module Authlib {
  /** Gets a reference to `authlib.jose.(jwt|JsonWebToken)` */
  private API::Node authlibJWT() {
    result in [
        API::moduleImport("authlib").getMember("jose").getMember("jwt"),
        API::moduleImport("authlib").getMember("jose").getMember("JsonWebToken").getReturn()
      ]
  }

  /** Gets a reference to `jwt.encode` */
  private API::Node authlibJWTEncode() { result = authlibJWT().getMember("encode") }

  /** Gets a reference to `jwt.decode` */
  private API::Node authlibJWTDecode() { result = authlibJWT().getMember("decode") }

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
  private class AuthlibJWTEncodeCall extends DataFlow::CallCfgNode, JWTEncoding::Range {
    AuthlibJWTEncodeCall() { this = authlibJWTEncode().getACall() }

    override DataFlow::Node getPayload() { result = this.getArg(1) }

    override DataFlow::Node getKey() { result = this.getArg(2) }

    override DataFlow::Node getAlgorithm() {
      exists(KeyValuePair headerDict |
        headerDict = this.getArg(0).asExpr().(Dict).getItem(_) and
        headerDict.getKey().(Str_).getS().matches("alg") and
        result.asExpr() = headerDict.getValue()
      )
    }

    override string getAlgorithmString() {
      exists(StrConst str |
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
  private class AuthlibJWTDecodeCall extends DataFlow::CallCfgNode, JWTDecoding::Range {
    AuthlibJWTDecodeCall() { this = authlibJWTDecode().getACall() }

    override DataFlow::Node getPayload() { result = this.getArg(0) }

    override DataFlow::Node getKey() { result = this.getArg(1) }

    override DataFlow::Node getAlgorithm() { none() }

    override string getAlgorithmString() { none() }

    override DataFlow::Node getOptions() { none() }

    override predicate verifiesSignature() { any() }
  }
}
