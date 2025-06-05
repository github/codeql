private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import semmle.code.cpp.dataflow.new.DataFlow

class EVPKeyGenInitialize extends EVPInitialize {
  EVPKeyGenInitialize() {
    this.(Call).getTarget().getName() in [
        "EVP_PKEY_keygen_init",
        "EVP_PKEY_paramgen_init"
      ]
  }

  override Expr getAlgorithmArg() {
    // The context argument encodes the algorithm
    result = this.getContextArg()
  }
}

// /**
//  * All calls that can be tracked via ctx.
//  * For example calls used to set parameters like a key size.
//  */
// class EVPKeyGenUpdate extends Call {
//   EVPKeyGenUpdate() {
//     this.(Call).getTarget().getName() in [
//         "EVP_PKEY_CTX_set_rsa_keygen_bits",
//         // TODO: "EVP_PKEY_CTX_set_params"
//       ]
//   }
//   /**
//    * No input in our meaning.
//    */
//   override Expr getInputArg() { none() }
//   /**
//    * No output in our meaning.
//    */
//   override Expr getOutputArg() { none() }
//   Expr getKeySizeArg() {
//     this.(Call).getTarget().getName() = "EVP_PKEY_CTX_set_rsa_keygen_bits" and
//     result = this.(Call).getArgument(1)
//   }
// }
class EVPKeyGenOperation extends EVPOperation, Crypto::KeyGenerationOperationInstance {
  DataFlow::Node keyResultNode;

  EVPKeyGenOperation() {
    this.(Call).getTarget().getName() in ["EVP_RSA_gen", "EVP_PKEY_Q_keygen"] and
    keyResultNode.asExpr() = this
    or
    this.(Call).getTarget().getName() in [
        "EVP_PKEY_generate", "EVP_PKEY_keygen", "EVP_PKEY_paramgen"
      ] and
    keyResultNode.asDefiningArgument() = this.(Call).getArgument(1)
  }

  override Expr getAlgorithmArg() {
    this.(Call).getTarget().getName() = "EVP_PKEY_Q_keygen" and
    result = this.(Call).getArgument(0)
    or
    result = this.getInitCall().getAlgorithmArg()
  }

  override Crypto::KeyArtifactType getOutputKeyType() { result = Crypto::TAsymmetricKeyType() }

  override Expr getInputArg() { none() }

  override Expr getOutputArg() { result = this.(Call).getArgument(1) }

  override Crypto::ArtifactOutputDataFlowNode getOutputKeyArtifact() { result = keyResultNode }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
    none()
    // if this.(Call).getTarget().getName() = "EVP_PKEY_Q_keygen"
    // then result = DataFlow::exprNode(this.(Call).getArgument(3)) // TODO: may be wrong for EC keys
    // else
    //   if this.(Call).getTarget().getName() = "EVP_RSA_gen"
    //   then result = DataFlow::exprNode(this.(Call).getArgument(0))
    //   else result = DataFlow::exprNode(this.getUpdateCalls().(EVPKeyGenUpdate).getKeySizeArg())
  }

  override int getKeySizeFixed() {
    none() // TODO
  }
}
