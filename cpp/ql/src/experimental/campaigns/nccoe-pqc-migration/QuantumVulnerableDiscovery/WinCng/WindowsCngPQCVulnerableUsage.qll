import cpp
import WindowsCng

predicate vulnerableCngFunctionName(string name) { name in ["BCryptSignHash", "BCryptEncrypt"] }

predicate keyGenAndImportFunctionName(string name) { name in ["BCryptImportKeyPair", "BCryptGenerateKeyPair"] }

predicate vulnerableCngFunction(Function f) {
  exists(string name | f.hasGlobalName(name) and vulnerableCngFunctionName(name))
}

predicate keyGenAndImportFunction(Function f){
    exists(string name | f.hasGlobalName(name) and keyGenAndImportFunctionName(name))
}

//TODO: Verify NCrypt calls (parameters) & find all other APIs that should be included (i.e. decrypt, etc.)
predicate isExprKeyHandleForBCryptSignHash(Expr e) {
  exists(FunctionCall call |
    e = call.getArgument(0) and
    vulnerableCngFunction(call.getTarget())
  )
}

class BCryptSignHashArgumentSink extends BCryptOpenAlgorithmProviderSink {
  BCryptSignHashArgumentSink() { isExprKeyHandleForBCryptSignHash(this.asExpr()) }
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
    keyGenAndImportFunction(call.getTarget()) and
    node2.asDefiningArgument() = call.getArgument(1)
  )
}

predicate isWindowsCngAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  stepOpenAlgorithmProvider(node1, node2)
  or
  stepImportGenerateKeyPair(node1, node2)
}
