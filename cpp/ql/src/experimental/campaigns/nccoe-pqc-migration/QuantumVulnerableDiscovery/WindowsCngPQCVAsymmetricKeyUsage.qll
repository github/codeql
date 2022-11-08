import cpp
import WindowsCng

//TODO: Verify NCrypt calls (parameters) & find all other APIs that should be included (i.e. decrypt, etc.)

predicate isExprAlgIdForBCryptOpenAlgorithmProvider(Expr e){
    exists( FunctionCall call |
        // BCryptOpenAlgorithmProvider 2nd argument specifies the algorithm to be used
        e = call.getArgument(1)
         and
         call.getTarget().hasGlobalName("BCryptOpenAlgorithmProvider")
    )
}

predicate isExprAlgHandleForBCryptGenerateOrImportKeyPair(Expr e){
    exists( FunctionCall call |
        e = call.getArgument(0)
         and
         ( call.getTarget().hasGlobalName("BCryptImportKeyPair") or 
         call.getTarget().hasGlobalName("BCryptGenerateKeyPair"))
    )
}

predicate isExprOutKeyHandleForBCryptGenerateOrImportKeyPair(Expr e){
    exists( FunctionCall call |
        ( e = call.getArgument(3) and call.getTarget().hasGlobalName("BCryptImportKeyPair") )or 
        ( e = call.getArgument(1) and  call.getTarget().hasGlobalName("BCryptGenerateKeyPair") )
    )
}

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

predicate isAdditionalTaintStepOpenAlgolrithmProviderToGenerateOrImportKeyPair(DataFlow::Node node1, DataFlow::Node node2)
{
    isExprAlgIdForBCryptOpenAlgorithmProvider(node1.asExpr()) and
    isExprAlgHandleForBCryptGenerateOrImportKeyPair(node2.asExpr())
}


predicate isAdditionalTaintStepWithinGenerateOrImportKeyPair(DataFlow::Node node1, DataFlow::Node node2)
{
    isExprAlgHandleForBCryptGenerateOrImportKeyPair(node1.asExpr()) and
    isExprOutKeyHandleForBCryptGenerateOrImportKeyPair(node2.asExpr())
}

predicate isAdditionalTaintStepGenerateOrImportKeyPairToSignHash(DataFlow::Node node1, DataFlow::Node node2)
{
    isExprOutKeyHandleForBCryptGenerateOrImportKeyPair(node1.asExpr()) and
    isExprKeyHandleForBCryptSignHash(node2.asExpr())
}

predicate isWindowsCngAsymmetricKeyAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    isAdditionalTaintStepOpenAlgolrithmProviderToGenerateOrImportKeyPair(node1, node2)
    or isAdditionalTaintStepWithinGenerateOrImportKeyPair(node1, node2) 
    or isAdditionalTaintStepGenerateOrImportKeyPairToSignHash(node1, node2)
}

