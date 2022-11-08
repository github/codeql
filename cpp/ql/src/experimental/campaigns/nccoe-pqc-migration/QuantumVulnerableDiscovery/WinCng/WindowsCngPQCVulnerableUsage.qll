import cpp
import WindowsCng

//TODO: Verify NCrypt calls (parameters) & find all other APIs that should be included (i.e. decrypt, etc.)


predicate isCallArgument(string funcGlobalName, Expr arg, int index){
    exists(Call c | c.getArgument(index) = arg and c.getTarget().hasGlobalName(funcGlobalName))
}

class BCryptSignHashArgumentSink extends BCryptOpenAlgorithmProviderSink {
  BCryptSignHashArgumentSink() { isCallArgument("BCryptSignHash", this.asExpr(), 0) }
}

class BCryptEncryptArgumentSink extends BCryptOpenAlgorithmProviderSink {
    BCryptEncryptArgumentSink() { isCallArgument("BCryptEncrypt", this.asExpr(), 0) }
  }
  

class BCryptOpenAlgorithmProviderPqcVulnerableAlgorithmsSource extends BCryptOpenAlgorithmProviderSource {
  BCryptOpenAlgorithmProviderPqcVulnerableAlgorithmsSource() {
    this.asExpr() instanceof StringLiteral and
    (
      this.asExpr().getValue() in ["DH", "DSA", "ECDSA", "ECDH"] or
      this.asExpr().getValue().matches("ECDH%") or
      this.asExpr().getValue().matches("RSA%")
    )
  }
}

predicate stepOpenAlgorithmProvider(DataFlow::Node node1, DataFlow::Node node2) {
  exists(FunctionCall call |
    // BCryptOpenAlgorithmProvider 2nd argument specifies the algorithm to be used
    node1.asExpr() = call.getArgument(1) and
    call.getTarget().hasGlobalName("BCryptOpenAlgorithmProvider") and
    node2.asDefiningArgument() = call.getArgument(0)
  )
}

predicate stepImportGenerateKeyPair(DataFlow::Node node1, DataFlow::Node node2) {
  exists(FunctionCall call |
    node1.asExpr() = call.getArgument(0) and
    exists(string name | name in ["BCryptImportKeyPair", "BCryptGenerateKeyPair"] and call.getTarget().hasGlobalName(name)) and
    node2.asDefiningArgument() = call.getArgument(1)
  )
}

predicate isWindowsCngAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  stepOpenAlgorithmProvider(node1, node2)
  or
  stepImportGenerateKeyPair(node1, node2)
}
