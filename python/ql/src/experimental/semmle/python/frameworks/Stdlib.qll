/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 * Note: some modeling is done internally in the dataflow/taint tracking implementation.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs
private import experimental.semmle.python.security.JWT

private module JWT {
  private class PyJWTEncodeCall extends DataFlow::CallCfgNode, JWTEncoding::Range {
    PyJWTEncodeCall() { this = API::moduleImport("jwt").getMember("encode").getACall() }

    override DataFlow::Node getKeyNode() {
      result = this.getArg(1) or result = this.getArgByName("key")
    }

    override DataFlow::Node getAlgorithmNode() {
      result = this.getArg(2) or
      result = this.getArgByName("algorithm")
    }

    override string getAlgorithm() {
      exists(StrConst str |
        DataFlow::exprNode(str).(DataFlow::LocalSourceNode).flowsTo(getAlgorithmNode()) and
        result = str.getText()
      )
    }
  }

  private class PyJWTDecodeCall extends DataFlow::CallCfgNode, JWTDecoding::Range {
    PyJWTDecodeCall() { this = API::moduleImport("jwt").getMember("decode").getACall() }

    override predicate verifiesSignature() {
      not isFalse(this.getArgByName("verify")) and
      not exists(KeyValuePair optionsDict, NameConstant falseName |
        falseName.getId() = "False" and
        optionsDict = this.getArgByName("options").asExpr().(Dict).getItems().getAnItem() and
        optionsDict.getKey().(Str_).getS().matches("verify_signature") and
        falseName = optionsDict.getValue()
      )
    }
  }
}
