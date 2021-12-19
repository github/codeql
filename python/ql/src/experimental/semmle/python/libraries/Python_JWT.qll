private import python
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

private module Python_JWT {
  /**
   * Gets a call to `python_jwt.process_jwt`.
   *
   * Given the following example:
   *
   * ```py
   * python_jwt.process_jwt(token)
   * python_jwt.verify_jwt(token, "key", "HS256")
   * ```
   *
   * * `this` would be `jwt.process_jwt(token)`.
   * * `getPayload()`'s result would be `token`.
   * * `getKey()`'s result would be `"key"`.
   * * `getAlgorithm()`'s result would be `"HS256"`.
   * * `getAlgorithmstring()`'s result would be `HS256`.
   * * `getOptions()`'s result would be `none()`.
   * * `verifiesSignature()` predicate would succeed.
   */
  private class Python_JWTProcessCall extends DataFlow::CallCfgNode, JWTDecoding::Range {
    DataFlow::CallCfgNode verifyCall;
    boolean verifiesSignature;

    Python_JWTProcessCall() {
      this = API::moduleImport("python_jwt").getMember("process_jwt").getACall() and
      (
        verifyCall = API::moduleImport("python_jwt").getMember("verify_jwt").getACall() and
        this.getArg(0).getALocalSource().flowsTo(verifyCall.getArg(0)) and
        verifiesSignature = true
        or
        verifiesSignature = false
      )
    }

    override DataFlow::Node getPayload() { result = this.getArg(0) }

    override DataFlow::Node getKey() { result = verifyCall.getArg(1) }

    override DataFlow::Node getAlgorithm() { result = verifyCall.getArg(2) }

    override string getAlgorithmString() {
      exists(StrConst str |
        DataFlow::exprNode(str).(DataFlow::LocalSourceNode).flowsTo(this.getAlgorithm()) and
        result = str.getText()
      )
    }

    override DataFlow::Node getOptions() { none() }

    override predicate verifiesSignature() { verifiesSignature = true }
  }
}
