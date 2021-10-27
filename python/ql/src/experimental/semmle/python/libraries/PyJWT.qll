private import python
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs
private import experimental.semmle.python.frameworks.JWT

private module PyJWT {
  /** Gets a reference to `jwt.encode` */
  private API::Node pyjwtEncode() { result = API::moduleImport("jwt").getMember("encode") }

  /** Gets a reference to `jwt.decode` */
  private API::Node pyjwtDecode() { result = API::moduleImport("jwt").getMember("decode") }

  // def encode(self, payload, key, algorithm="HS256", headers=None, json_encoder=None)
  private class PyJWTEncodeCall extends DataFlow::CallCfgNode, JWTEncoding::Range {
    PyJWTEncodeCall() { this = pyjwtEncode().getACall() }

    override DataFlow::Node getPayload() {
      result in [this.getArg(0), this.getArgByName("payload")]
    }

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

  // def decode(self, jwt, key="", algorithms=None, options=None)
  private class PyJWTDecodeCall extends DataFlow::CallCfgNode, JWTDecoding::Range {
    PyJWTDecodeCall() { this = pyjwtDecode().getACall() }

    override DataFlow::Node getPayload() { result in [this.getArg(0), this.getArgByName("jwt")] }

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
      not exists(this.getArgByName("verify")) and not exists(this.getOptions())
      or
      // jwt.decode(token, verify=False)
      not isFalse(this.getArgByName("verify")) and
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
