private import python
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs
private import experimental.semmle.python.frameworks.JWT

private module Authlib {
  /** Gets a reference to `authlib.jose` */
  private API::Node authlib() { result = API::moduleImport("authlib.jose") }

  /** Gets a reference to `authlib.jose.(jwt|JsonWebToken)` */
  private API::Node authlibJWT() {
    result in [authlib().getMember("jwt"), authlib().getMember("JsonWebToken").getReturn()]
  }

  /** Gets a reference to `jwt.encode` */
  private API::Node authlibJWTEncode() { result = authlibJWT().getMember("encode") }

  /** Gets a reference to `jwt.decode` */
  private API::Node authlibJWTDecode() { result = authlibJWT().getMember("decode") }

  // def encode(self, header, payload, key, check=True):
  private class AuthlibJWTEncodeCall extends DataFlow::CallCfgNode, JWTEncoding::Range {
    AuthlibJWTEncodeCall() { this = authlibJWTEncode().getACall() }

    override DataFlow::Node getPayload() { result = this.getArg(1) }

    override DataFlow::Node getKey() { result = this.getArg(2) }

    override DataFlow::Node getAlgorithm() {
      exists(KeyValuePair headerDict |
        headerDict = this.getArg(0).asExpr().(Dict).getItems().getAnItem() and
        headerDict.getKey().(Str_).getS().matches("alg") and
        result.asExpr() = headerDict.getValue()
      )
    }

    override string getAlgorithmString() {
      exists(StrConst str |
        DataFlow::exprNode(str).(DataFlow::LocalSourceNode).flowsTo(getAlgorithm()) and
        result = str.getText()
      )
    }
  }

  // def decode(self, s, key, claims_cls=None, claims_options=None, claims_params=None):
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
