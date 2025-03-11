import experimental.Quantum.Language
import CtxFlow as CTXFlow
import EVPCipherInitializer
import EVPCipherConsumers

//https://docs.openssl.org/master/man3/EVP_EncryptInit/#synopsis
abstract class EVP_Cipher_Operation extends Crypto::CipherOperationInstance instanceof Call {
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  abstract Expr getInputArg();

  Expr getOutputArg() { result = this.(Call).getArgument(1) }

  override Crypto::CipherOperationSubtype getCipherOperationSubtype() {
    result instanceof Crypto::EncryptionSubtype and
    this.(Call).getTarget().getName().toLowerCase().matches("%encrypt%")
    or
    result instanceof Crypto::DecryptionSubtype and
    this.(Call).getTarget().getName().toLowerCase().matches("%decrypt%")
    or
    result = this.getInitCall().getCipherOperationSubtype() and
    this.(Call).getTarget().getName().toLowerCase().matches("%cipher%")
  }

  EVP_Cipher_Inititalizer getInitCall() {
    CTXFlow::ctxFlowsTo(result.getContextArg(), this.getContextArg())
  }

  override Crypto::NonceArtifactConsumer getNonceConsumer() {
    this.getInitCall().getIVArg() = result
  }

  override Crypto::CipherInputConsumer getInputConsumer() { this.getInputArg() = result }

  override Crypto::CipherOutputArtifactInstance getOutputArtifact() { this.getOutputArg() = result }

  override Crypto::AlgorithmConsumer getAlgorithmConsumer() {
    this.getInitCall().getAlgorithmArg() = result
  }
}

abstract class EVP_Update_Call extends EVP_Cipher_Operation { }

abstract class EVP_Final_Call extends EVP_Cipher_Operation {
  override Expr getInputArg() { none() }
}

class EVP_Cipher_Call extends EVP_Cipher_Operation {
  EVP_Cipher_Call() { this.(Call).getTarget().getName() = "EVP_Cipher" }

  override Expr getInputArg() { result = this.(Call).getArgument(2) }
}

class EVP_Encrypt_Decrypt_or_Cipher_Update_Call extends EVP_Update_Call {
  EVP_Encrypt_Decrypt_or_Cipher_Update_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptUpdate", "EVP_DecryptUpdate", "EVP_CipherUpdate"
      ]
  }

  override Expr getInputArg() { result = this.(Call).getArgument(3) }
}

class EVP_Encrypt_Decrypt_or_Cipher_Final_Call extends EVP_Final_Call {
  EVP_Encrypt_Decrypt_or_Cipher_Final_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptFinal_ex", "EVP_DecryptFinal_ex", "EVP_CipherFinal_ex", "EVP_EncryptFinal",
        "EVP_DecryptFinal", "EVP_CipherFinal"
      ]
  }
}

class EVPCipherOutput extends CipherOutputArtifact {
  EVPCipherOutput() { exists(EVP_Cipher_Operation op | op.getOutputArg() = this) }

  override DataFlow::Node getOutputNode() { result.asExpr() = this }
}

class EVPCipherInputArgument extends Expr {
  EVPCipherInputArgument() { exists(EVP_Cipher_Operation op | op.getInputArg() = this) }
}
