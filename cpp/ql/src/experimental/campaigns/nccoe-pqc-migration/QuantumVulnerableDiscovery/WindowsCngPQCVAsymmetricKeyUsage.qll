import cpp
import WindowsCng
//TODO: Verify NCrypt calls (parameters) & find all other APIs that should be included (i.e. decrypt, etc.)
predicate isExprKeyHandleForBCryptSignHash(Expr e){
    exists( FunctionCall call |
        e = call.getArgument(0)
         and
         call.getTarget().hasGlobalName("BCryptSignHash")
    )
}

class BCryptSignHashArgumentSink extends BCryptOpenAlgorithmProviderSink {
    BCryptSignHashArgumentSink() {
    isExprKeyHandleForBCryptSignHash(this.asExpr())
  }
}

class BCryptOpenAlgorithmProviderPqcVulnerableAlgorithmsSource extends BCryptOpenAlgorithmProviderSource {
    BCryptOpenAlgorithmProviderPqcVulnerableAlgorithmsSource() {
        this.asExpr() instanceof StringLiteral and
        (
            this.asExpr().getValue() in ["DH", "DSA", "ECDSA", "ECDH"]
            or this.asExpr().getValue().matches("ECDH%")
            or this.asExpr().getValue().matches("RSA%")
        )
    }
}

predicate stepOpenAlgorithmProvider(DataFlow::Node node1, DataFlow::Node node2)
{
    exists( FunctionCall call |
        // BCryptOpenAlgorithmProvider 2nd argument specifies the algorithm to be used
        node1.asExpr() = call.getArgument(1)
         and
         call.getTarget().hasGlobalName("BCryptOpenAlgorithmProvider")
        and
        node2.asDefiningArgument() = call.getArgument(0)
    )
}

predicate stepImportGenerateKeyPair(DataFlow::Node node1, DataFlow::Node node2)
{
    exists( FunctionCall call |
        node1.asExpr() = call.getArgument(0)
        and
        ( call.getTarget().hasGlobalName("BCryptImportKeyPair") or 
        call.getTarget().hasGlobalName("BCryptGenerateKeyPair"))
        and
        node2.asDefiningArgument() = call.getArgument(1)
    )
}

predicate isWindowsCngAsymmetricKeyAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    stepOpenAlgorithmProvider(node1, node2) 
    or 
    stepImportGenerateKeyPair(node1, node2)
}