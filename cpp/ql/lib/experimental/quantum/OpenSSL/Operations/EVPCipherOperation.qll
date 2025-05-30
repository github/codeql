private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow as CTXFlow
private import EVPCipherInitializer
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

private module AlgGetterToAlgConsumerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(OpenSSLAlgorithmValueConsumer c | c.getResultNode() = source)
  }

  predicate isSink(DataFlow::Node sink) {
    exists(EVP_Cipher_Operation c | c.getAlgorithmArg() = sink.asExpr())
  }
}

private module AlgGetterToAlgConsumerFlow = DataFlow::Global<AlgGetterToAlgConsumerConfig>;

// import experimental.quantum.OpenSSL.AlgorithmValueConsumers.AlgorithmValueConsumers
// import OpenSSLOperation
// class EVPCipherOutput extends CipherOutputArtifact {
//   EVPCipherOutput() { exists(EVP_Cipher_Operation op | op.getOutputArg() = this) }
//   override DataFlow::Node getOutputNode() { result.asDefiningArgument() = this }
// }
//
/**
 * see: https://docs.openssl.org/master/man3/EVP_EncryptInit/#synopsis
 * Base configuration for all EVP cipher operations.
 * NOTE: cannot extend instance of OpenSSLOperation, as we need to override
 * elements of OpenSSLOperation (i.e., we are creating an instance)
 */
abstract class EVP_Cipher_Operation extends OpenSSLOperation, Crypto::KeyOperationInstance {
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  Expr getAlgorithmArg() { this.getInitCall().getAlgorithmArg() = result }

  override Expr getOutputArg() { result = this.(Call).getArgument(1) }

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    result instanceof Crypto::TEncryptMode and
    this.(Call).getTarget().getName().toLowerCase().matches("%encrypt%")
    or
    result instanceof Crypto::TDecryptMode and
    this.(Call).getTarget().getName().toLowerCase().matches("%decrypt%")
    or
    result = this.getInitCall().getCipherOperationSubtype() and
    this.(Call).getTarget().getName().toLowerCase().matches("%cipher%")
  }

  EVP_Cipher_Initializer getInitCall() {
    CTXFlow::ctxArgFlowsToCtxArg(result.getContextArg(), this.getContextArg())
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
    this.getInitCall().getIVArg() = result.asExpr()
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() { result = this.getInputNode() }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    this.getInitCall().getKeyArg() = result.asExpr()
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() { result = this.getOutputNode() }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    AlgGetterToAlgConsumerFlow::flow(result.(OpenSSLAlgorithmValueConsumer).getResultNode(),
      DataFlow::exprNode(this.getInitCall().getAlgorithmArg()))
  }
}

class EVP_Cipher_Call extends EVP_Cipher_Operation {
  EVP_Cipher_Call() { this.(Call).getTarget().getName() = "EVP_Cipher" }

  override Expr getInputArg() { result = this.(Call).getArgument(2) }
}

// NOTE: not modeled as cipher operations, these are intermediate calls
class EVP_Cipher_Update_Call extends Call {
  EVP_Cipher_Update_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptUpdate", "EVP_DecryptUpdate", "EVP_CipherUpdate"
      ]
  }

  Expr getInputArg() { result = this.(Call).getArgument(3) }

  DataFlow::Node getInputNode() { result.asExpr() = this.getInputArg() }

  Expr getContextArg() { result = this.(Call).getArgument(0) }
}

class EVP_Cipher_Final_Call extends EVP_Cipher_Operation {
  EVP_Cipher_Final_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptFinal_ex", "EVP_DecryptFinal_ex", "EVP_CipherFinal_ex", "EVP_EncryptFinal",
        "EVP_DecryptFinal", "EVP_CipherFinal"
      ]
  }

  EVP_Cipher_Update_Call getUpdateCalls() {
    CTXFlow::ctxArgFlowsToCtxArg(result.getContextArg(), this.getContextArg())
  }

  override Expr getInputArg() { result = this.getUpdateCalls().getInputArg() }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() { result = this.getInputNode() }
}

class EVP_PKEY_Operation extends EVP_Cipher_Operation {
  EVP_PKEY_Operation() {
    this.(Call).getTarget().getName() in ["EVP_PKEY_decrypt", "EVP_PKEY_encrypt"]
  }

  override Expr getInputArg() { result = this.(Call).getArgument(3) }
  // TODO: how PKEY is initialized is different that symmetric cipher
  // Consider making an entirely new class for this and specializing
  // the get init call
}

class EVPCipherInputArgument extends Expr {
  EVPCipherInputArgument() { exists(EVP_Cipher_Operation op | op.getInputArg() = this) }
}
