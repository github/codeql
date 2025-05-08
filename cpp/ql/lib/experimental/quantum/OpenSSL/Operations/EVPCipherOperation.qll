import experimental.quantum.Language
import experimental.quantum.OpenSSL.CtxFlow as CTXFlow
import EVPCipherInitializer
import OpenSSLOperationBase
import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

private module AlgGetterToAlgConsumerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(OpenSSLAlgorithmValueConsumer c | c.getResultNode() = source)
  }

  predicate isSink(DataFlow::Node sink) {
    exists(EVP_Cipher_Operation c | c.getInitCall().getAlgorithmArg() = sink.asExpr())
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

  EVP_Cipher_Inititalizer getInitCall() {
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

// abstract class EVP_Update_Call extends EVP_Cipher_Operation { }
abstract class EVP_Final_Call extends EVP_Cipher_Operation {
  override Expr getInputArg() { none() }
}

// TODO: only model Final (model final as operation and model update but not as an operation)
// Updates are multiple input consumers (most important)
// PUNT assuming update doesn't ouput, otherwise it outputs arifacts, but is not an operation
class EVP_Cipher_Call extends EVP_Cipher_Operation {
  EVP_Cipher_Call() { this.(Call).getTarget().getName() = "EVP_Cipher" }

  override Expr getInputArg() { result = this.(Call).getArgument(2) }
}

// ******* TODO  NEED to model UPDATE but not as the coree operation, rather a step towards final,
// see the JCA
// class EVP_Encrypt_Decrypt_or_Cipher_Update_Call extends EVP_Update_Call {
//   EVP_Encrypt_Decrypt_or_Cipher_Update_Call() {
//     this.(Call).getTarget().getName() in [
//         "EVP_EncryptUpdate", "EVP_DecryptUpdate", "EVP_CipherUpdate"
//       ]
//   }
//   override Expr getInputArg() { result = this.(Call).getArgument(3) }
// }
class EVP_Encrypt_Decrypt_or_Cipher_Final_Call extends EVP_Final_Call {
  EVP_Encrypt_Decrypt_or_Cipher_Final_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptFinal_ex", "EVP_DecryptFinal_ex", "EVP_CipherFinal_ex", "EVP_EncryptFinal",
        "EVP_DecryptFinal", "EVP_CipherFinal"
      ]
  }
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
