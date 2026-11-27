/**
 * @name Verify hash before decryption
 * @description 
 * @kind problem
 * @id cs/verify-hash-before-decryption
 * @problem.severity error
 * @precision medium
 * @tags security
 */
import csharp
import semmle.code.csharp.dataflow.TaintTracking::TaintTracking

class CryptoStreamWrite extends MethodCall {
  CryptoStreamWrite() {
    getTarget().hasQualifiedName("System.Security.Cryptography.CryptoStream", "Write")
  }

  /** Holds if this is a decryptor stream. */
  predicate isDecryptor() {
    any(CryptoStreamTaintTrackingConfig c).hasFlow(_, DataFlow::exprNode(getQualifier()))
  }
}

class ComputeHash extends MethodCall {
  ComputeHash() {
    getTarget().hasName("ComputeHash")
  }
}
 
class ByteArrayTaintTrackingConfig extends TaintTracking::Configuration  {
  ByteArrayTaintTrackingConfig() { this = "Byte array that is being passed to cryptostream write" }
 
  override predicate isSource(DataFlow::Node source) {    
    source.asExpr().getType().(ArrayType).getElementType().hasName("Byte")
  }
 
  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(CryptoStreamWrite cw).getArgument(0) or
    sink.asExpr() = any(ComputeHash ch).getArgument(0)
  }
}

class CryptoStreamTaintTrackingConfig extends TaintTracking::Configuration  {
  CryptoStreamTaintTrackingConfig() { this = "CryptoStreamTaintTracking" }

  override predicate isSource(DataFlow::Node source) {
    exists(ObjectCreation oc |
      oc = source.asExpr() and
      oc.getTarget().getDeclaringType().hasName("CryptoStream") and
      oc.getArgument(1).(MethodCall).getTarget().hasQualifiedName("System.Security.Cryptography.SymmetricAlgorithm", "CreateDecryptor")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(CryptoStreamWrite csw).getQualifier()
  }
}
 
from ByteArrayTaintTrackingConfig config, Expr arrayDefinition, CryptoStreamWrite writeCall
where config.hasFlow(DataFlow::exprNode(arrayDefinition), DataFlow::exprNode(writeCall.getArgument(0)))
  and writeCall.isDecryptor()
  and not exists(ComputeHash c | config.hasFlow(DataFlow::exprNode(arrayDefinition), DataFlow::exprNode(c.getArgument(0))))
select arrayDefinition, "Byte array passed to CryptoStream $@, never has the hash computed.", arrayDefinition, "here"
 