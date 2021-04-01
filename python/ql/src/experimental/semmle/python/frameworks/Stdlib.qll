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

    override string getAlgorithm() { result = getAlgorithmNode().asExpr().(Str_).getS() }
  }

  private class PyJWTDecodeCall extends DataFlow::CallCfgNode, JWTDecoding::Range {
    PyJWTDecodeCall() { this = API::moduleImport("jwt").getMember("decode").getACall() }

    override predicate verifiesSignature() {
      not exists(NameConstant falseName |
        falseName.getId() = "False" and
        exists( | falseName = this.getArgByName("verify").asExpr())
        or
        exists(KeyValuePair optionsDict |
          optionsDict = this.getArgByName("options").asExpr().(Dict).getItems().getAnItem() and
          optionsDict.getKey().(Str_).getS().matches("verify_signature") and
          falseName = optionsDict.getValue()
        )
      )
    }
  }
}
