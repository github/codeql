private import python
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs
private import experimental.semmle.python.frameworks.JWT

private module PythonJose {
  /** Gets a reference to `jwt` */
  private API::Node joseJWT() { result = API::moduleImport("jose").getMember("jwt") }

  /** Gets a reference to `jwt.encode` */
  private API::Node joseJWTEncode() { result = joseJWT().getMember("encode") }

  /** Gets a reference to `jwt.decode` */
  private API::Node joseJWTDecode() { result = joseJWT().getMember("decode") }

  // def encode(claims, key, algorithm=ALGORITHMS.HS256, headers=None, access_token=None):
  private class JoseJWTEncodeCall extends DataFlow::CallCfgNode, JWTEncoding::Range {
    JoseJWTEncodeCall() { this = joseJWTEncode().getACall() }

    override DataFlow::Node getPayload() { result = this.getArg(0) }

    override DataFlow::Node getKey() { result in [this.getArg(1), this.getArgByName("key")] }

    override DataFlow::Node getAlgorithm() {
      result in [this.getArg(2), this.getArgByName("algorithm")]
    }

    override string getAlgorithmString() {
      exists(StrConst str |
        DataFlow::exprNode(str).(DataFlow::LocalSourceNode).flowsTo(getAlgorithm()) and
        result = str.getText()
      )
    }
  }

  // def decode(token, key, algorithms=None, options=None, audience=None, issuer=None, subject=None, access_token=None):
  private class JoseJWTDecodeCall extends DataFlow::CallCfgNode, JWTDecoding::Range {
    JoseJWTDecodeCall() { this = joseJWTDecode().getACall() }

    override DataFlow::Node getPayload() { result = this.getArg(0) }

    override DataFlow::Node getKey() { result in [this.getArg(1), this.getArgByName("key")] }

    override DataFlow::Node getAlgorithm() {
      result in [this.getArg(2), this.getArgByName("algorithms")]
    }

    override string getAlgorithmString() {
      exists(StrConst str |
        DataFlow::exprNode(str).(DataFlow::LocalSourceNode).flowsTo(getAlgorithm()) and
        result = str.getText()
      )
    }

    override DataFlow::Node getOptions() {
      result in [this.getArg(3), this.getArgByName("options")]
    }

    override predicate verifiesSignature() {
      // jwt.decode(token, "key", "HS256")
      not exists(this.getOptions())
      or
      // jwt.decode(token, key, options={"verify_signature": False})
      not exists(KeyValuePair optionsDict, NameConstant falseName |
        falseName.getId() = "False" and
        optionsDict = this.getOptions().asExpr().(Dict).getItems().getAnItem() and
        optionsDict.getKey().(Str_).getS().matches("%verify%") and
        falseName = optionsDict.getValue()
      )
    }
  }
}
