import experimental.Quantum.Language
import CtxFlow as CTXFlow
import LibraryDetector
import EVPHashInitializer
import EVPHashConsumers

abstract class EVP_Hash_Operation extends Crypto::HashOperationInstance instanceof Call {
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  EVP_Hash_Inititalizer getInitCall() {
    CTXFlow::ctxFlowsTo(result.getContextArg(), this.getContextArg())
  }
}

//https://docs.openssl.org/3.0/man3/EVP_DigestInit/#synopsis
class EVP_Q_Digest_Operation extends EVP_Hash_Operation {
  EVP_Q_Digest_Operation() {
    this.(Call).getTarget().getName() = "EVP_Q_digest" and
    isPossibleOpenSSLFunction(this.(Call).getTarget())
  }

  override Crypto::AlgorithmConsumer getAlgorithmConsumer() { this.(Call).getArgument(1) = result }

  override EVP_Hash_Inititalizer getInitCall() {
    // This variant of digest does not use an init
    // and even if it were used, the init would be ignored/undefined
    none()
  }
}

class EVP_Q_Digest_Algorithm_Argument extends Expr {
  EVP_Q_Digest_Algorithm_Argument() {
    exists(EVP_Q_Digest_Operation op | this = op.(Call).getArgument(1))
  }
}

class EVP_Digest_Operation extends EVP_Hash_Operation {
  EVP_Digest_Operation() {
    this.(Call).getTarget().getName() = "EVP_Digest" and
    isPossibleOpenSSLFunction(this.(Call).getTarget())
  }

  // There is no context argument for this function
  override Expr getContextArg() { none() }

  override Crypto::AlgorithmConsumer getAlgorithmConsumer() { this.(Call).getArgument(4) = result }

  override EVP_Hash_Inititalizer getInitCall() {
    // This variant of digest does not use an init
    // and even if it were used, the init would be ignored/undefined
    none()
  }
}

class EVP_Digest_Algorithm_Argument extends Expr {
  EVP_Digest_Algorithm_Argument() {
    exists(EVP_Digest_Operation op | this = op.(Call).getArgument(4))
  }
}

class EVP_DigestUpdate_Operation extends EVP_Hash_Operation {
  EVP_DigestUpdate_Operation() {
    this.(Call).getTarget().getName() = "EVP_DigestUpdate" and
    isPossibleOpenSSLFunction(this.(Call).getTarget())
  }

  override Crypto::AlgorithmConsumer getAlgorithmConsumer() {
    this.getInitCall().getAlgorithmArg() = result
  }
}

class EVP_DigestFinal_Variants_Operation extends EVP_Hash_Operation {
  EVP_DigestFinal_Variants_Operation() {
    this.(Call).getTarget().getName() in [
        "EVP_DigestFinal", "EVP_DigestFinal_ex", "EVP_DigestFinalXOF"
      ] and
    isPossibleOpenSSLFunction(this.(Call).getTarget())
  }

  override Crypto::AlgorithmConsumer getAlgorithmConsumer() {
    this.getInitCall().getAlgorithmArg() = result
  }
}
