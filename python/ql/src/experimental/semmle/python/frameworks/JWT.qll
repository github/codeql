private import python
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

predicate isEmptyOrNone(DataFlow::Node arg) { isEmpty(arg) or isNone(arg) }

predicate isEmpty(DataFlow::Node arg) {
  exists(StrConst emptyString |
    emptyString.getText() = "" and
    DataFlow::exprNode(emptyString).(DataFlow::LocalSourceNode).flowsTo(arg)
  )
}

predicate isNone(DataFlow::Node arg) {
  exists( | DataFlow::exprNode(any(None no)).(DataFlow::LocalSourceNode).flowsTo(arg))
}

predicate isFalse(DataFlow::Node arg) {
  exists( | DataFlow::exprNode(any(False falseExpr)).(DataFlow::LocalSourceNode).flowsTo(arg))
}

private module JWT {
  /** Gets a reference to `jwt` */
  private API::Node pyjwt() { result = API::moduleImport("jwt") }

  /** Gets a reference to `jwt.encode` */
  private API::Node pyjwt_encode() { result = pyjwt().getMember("encode") }

  /** Gets a reference to `jwt.decode` */
  private API::Node pyjwt_decode() { result = pyjwt().getMember("decode") }

  private class PyJWTEncodeCall extends DataFlow::CallCfgNode, JWTEncoding::Range {
    PyJWTEncodeCall() { this = pyjwt_encode().getACall() }

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

  private class PyJWTDecodeCall extends DataFlow::CallCfgNode, JWTDecoding::Range {
    PyJWTDecodeCall() { this = pyjwt_decode().getACall() }

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
        optionsDict = this.getArgByName("options").asExpr().(Dict).getItems().getAnItem() and
        optionsDict.getKey().(Str_).getS().matches("%verify%") and
        falseName = optionsDict.getValue()
      )
    }
  }
}
