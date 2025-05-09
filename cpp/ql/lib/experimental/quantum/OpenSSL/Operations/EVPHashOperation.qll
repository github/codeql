/**
 * https://docs.openssl.org/3.0/man3/EVP_DigestInit/#synopsis
 */

import experimental.quantum.Language
import experimental.quantum.OpenSSL.CtxFlow as CTXFlow
import experimental.quantum.OpenSSL.LibraryDetector
import OpenSSLOperationBase
import EVPHashInitializer
import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

// import EVPHashConsumers
abstract class EVP_Hash_Operation extends OpenSSLOperation, Crypto::HashOperationInstance {
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  EVP_Hash_Initializer getInitCall() {
    CTXFlow::ctxArgFlowsToCtxArg(result.getContextArg(), this.getContextArg())
  }
}

private module AlgGetterToAlgConsumerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(OpenSSLAlgorithmValueConsumer c | c.getResultNode() = source)
  }

  predicate isSink(DataFlow::Node sink) {
    exists(EVP_Hash_Operation c | c.getInitCall().getAlgorithmArg() = sink.asExpr())
  }
}

private module AlgGetterToAlgConsumerFlow = DataFlow::Global<AlgGetterToAlgConsumerConfig>;

//https://docs.openssl.org/3.0/man3/EVP_DigestInit/#synopsis
class EVP_Q_Digest_Operation extends EVP_Hash_Operation {
  EVP_Q_Digest_Operation() {
    this.(Call).getTarget().getName() = "EVP_Q_digest" and
    isPossibleOpenSSLFunction(this.(Call).getTarget())
  }

  //override Crypto::AlgorithmConsumer getAlgorithmConsumer() {  }
  override EVP_Hash_Initializer getInitCall() {
    // This variant of digest does not use an init
    // and even if it were used, the init would be ignored/undefined
    none()
  }

  override Expr getOutputArg() { result = this.(Call).getArgument(5) }

  override Expr getInputArg() { result = this.(Call).getArgument(3) }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() { result = this.getOutputNode() }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() { result = this.getInputNode() }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    // The operation is a direct algorithm consumer
    // NOTE: the operation itself is already modeld as a value consumer, so we can
    // simply return 'this', see modeled hash algorithm consuers for EVP_Q_Digest
    this = result
  }
}

class EVP_Digest_Operation extends EVP_Hash_Operation {
  EVP_Digest_Operation() {
    this.(Call).getTarget().getName() = "EVP_Digest" and
    isPossibleOpenSSLFunction(this.(Call).getTarget())
  }

  // There is no context argument for this function
  override Expr getContextArg() { none() }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    AlgGetterToAlgConsumerFlow::flow(result.(OpenSSLAlgorithmValueConsumer).getResultNode(),
      DataFlow::exprNode(this.(Call).getArgument(4)))
  }

  override EVP_Hash_Initializer getInitCall() {
    // This variant of digest does not use an init
    // and even if it were used, the init would be ignored/undefined
    none()
  }

  override Expr getOutputArg() { result = this.(Call).getArgument(2) }

  override Expr getInputArg() { result = this.(Call).getArgument(0) }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() { result = this.getOutputNode() }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() { result = this.getInputNode() }
}
// // override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
// //   AlgGetterToAlgConsumerFlow::flow(result.(OpenSSLAlgorithmValueConsumer).getResultNode(),
// //     DataFlow::exprNode(this.getInitCall().getAlgorithmArg()))
// // }
// // ***** TODO *** complete modelinlg for hash operations, but have consideration for terminal and non-terminal (non intermedaite) steps
// // see the JCA. May need to update the cipher operations similarly
// // ALSO SEE cipher for how we currently model initialization of the algorithm through an init call
// class EVP_DigestUpdate_Operation extends EVP_Hash_Operation {
//   EVP_DigestUpdate_Operation() {
//     this.(Call).getTarget().getName() = "EVP_DigestUpdate" and
//     isPossibleOpenSSLFunction(this.(Call).getTarget())
//   }
//   override Crypto::AlgorithmConsumer getAlgorithmConsumer() {
//     this.getInitCall().getAlgorithmArg() = result
//   }
// }
// class EVP_DigestFinal_Variants_Operation extends EVP_Hash_Operation {
//   EVP_DigestFinal_Variants_Operation() {
//     this.(Call).getTarget().getName() in [
//         "EVP_DigestFinal", "EVP_DigestFinal_ex", "EVP_DigestFinalXOF"
//       ] and
//     isPossibleOpenSSLFunction(this.(Call).getTarget())
//   }
//   override Crypto::AlgorithmConsumer getAlgorithmConsumer() {
//     this.getInitCall().getAlgorithmArg() = result
//   }
// }
