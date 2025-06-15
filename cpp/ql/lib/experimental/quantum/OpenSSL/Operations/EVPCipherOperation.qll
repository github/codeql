private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

// TODO: need to add key consumer
abstract class EVP_Cipher_Initializer extends EvpKeyOperationSubtypeInitializer,
  EvpPrimaryAlgorithmInitializer, EvpKeyInitializer, EvpIVInitializer
{
  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }

  override Expr getAlgorithmArg() { result = this.(Call).getArgument(1) }
}

abstract class EVP_EX_Initializer extends EVP_Cipher_Initializer {
  override Expr getKeyArg() {
    // Null key indicates the key is not actually set
    // This pattern can occur during a multi-step initialization
    // TODO/Note: not flowing 0 to the sink, assuming a direct use of NULL for now
    result = this.(Call).getArgument(3) and
    (exists(result.getValue()) implies result.getValue().toInt() != 0)
  }

  override Expr getIVArg() {
    // Null IV indicates the IV is not actually set
    // This occurs given that setting the IV sometimes requires first setting the IV size.
    // TODO/Note: not flowing 0 to the sink, assuming a direct use of NULL for now
    result = this.(Call).getArgument(4) and
    (exists(result.getValue()) implies result.getValue().toInt() != 0)
  }
}

abstract class EVP_EX2_Initializer extends EVP_Cipher_Initializer {
  override Expr getKeyArg() { result = this.(Call).getArgument(2) }

  override Expr getIVArg() { result = this.(Call).getArgument(3) }
}

class EvpCipherEXInitCall extends EVP_EX_Initializer {
  EvpCipherEXInitCall() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptInit_ex", "EVP_DecryptInit_ex", "EVP_CipherInit_ex"
      ]
  }

  override Expr getKeyOperationSubtypeArg() {
    // NOTE: for EncryptInit and DecryptInit there is no subtype arg
    // the subtype is determined automatically by the initializer based on the operation name
    this.(Call).getTarget().getName().toLowerCase().matches("%cipherinit%") and
    result = this.(Call).getArgument(5)
  }
}

//   if this.(Call).getTarget().getName().toLowerCase().matches("%encrypt%")
//   then result instanceof Crypto::TEncryptMode
//   else
//     if this.(Call).getTarget().getName().toLowerCase().matches("%decrypt%")
//     then result instanceof Crypto::TDecryptMode
class EVP_Cipher_EX2_or_Simple_Init_Call extends EVP_EX2_Initializer {
  EVP_Cipher_EX2_or_Simple_Init_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptInit_ex2", "EVP_DecryptInit_ex2", "EVP_CipherInit_ex2", "EVP_EncryptInit",
        "EVP_DecryptInit", "EVP_CipherInit"
      ]
  }

  override Expr getKeyOperationSubtypeArg() {
    this.(Call).getTarget().getName().toLowerCase().matches("%cipherinit%") and
    result = this.(Call).getArgument(4)
  }
}

class EVP_CipherInit_SKEY_Call extends EVP_EX2_Initializer {
  EVP_CipherInit_SKEY_Call() { this.(Call).getTarget().getName() in ["EVP_CipherInit_SKEY"] }

  override Expr getKeyOperationSubtypeArg() { result = this.(Call).getArgument(5) }
}

class EVP_Cipher_Update_Call extends EvpUpdate {
  EVP_Cipher_Update_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptUpdate", "EVP_DecryptUpdate", "EVP_CipherUpdate"
      ]
  }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }

  override Expr getInputArg() { result = this.(Call).getArgument(3) }

  override Expr getOutputArg() { result = this.(Call).getArgument(1) }
}

/**
 * see: https://docs.openssl.org/master/man3/EVP_EncryptInit/#synopsis
 * Base configuration for all EVP cipher operations.
 */
abstract class EVP_Cipher_Operation extends EvpOperation, Crypto::KeyOperationInstance {
  override Expr getOutputArg() { result = this.(Call).getArgument(1) }

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    result instanceof Crypto::TEncryptMode and
    this.(Call).getTarget().getName().toLowerCase().matches("%encrypt%")
    or
    result instanceof Crypto::TDecryptMode and
    this.(Call).getTarget().getName().toLowerCase().matches("%decrypt%")
    or
    result = this.getInitCall().(EvpKeyOperationSubtypeInitializer).getKeyOperationSubtype() and
    this.(Call).getTarget().getName().toLowerCase().matches("%cipher%")
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
    this.getInitCall().(EvpIVInitializer).getIVArg() = result.asExpr()
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    this.getInitCall().(EvpKeyInitializer).getKeyArg() = result.asExpr()
    // todo: or track to the EVP_PKEY_CTX_new
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result = EvpOperation.super.getOutputArtifact()
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result = EvpOperation.super.getInputConsumer()
  }
}

class EVP_Cipher_Call extends EvpOperation, EVP_Cipher_Operation {
  EVP_Cipher_Call() { this.(Call).getTarget().getName() = "EVP_Cipher" }

  override Expr getInputArg() { result = this.(Call).getArgument(2) }

  override Expr getAlgorithmArg() {
    result = this.getInitCall().(EvpPrimaryAlgorithmInitializer).getAlgorithmArg()
  }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

class EVP_Cipher_Final_Call extends EVPFinal, EVP_Cipher_Operation {
  EVP_Cipher_Final_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptFinal_ex", "EVP_DecryptFinal_ex", "EVP_CipherFinal_ex", "EVP_EncryptFinal",
        "EVP_DecryptFinal", "EVP_CipherFinal"
      ]
  }

  /**
   * Output is both from update calls and from the final call.
   */
  override Expr getOutputArg() {
    result = EVPFinal.super.getOutputArg()
    or
    result = EVP_Cipher_Operation.super.getOutputArg()
  }

  override Expr getAlgorithmArg() {
    result = this.getInitCall().(EvpPrimaryAlgorithmInitializer).getAlgorithmArg()
  }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

/**
 * https://docs.openssl.org/3.2/man3/EVP_PKEY_decrypt/
 * https://docs.openssl.org/3.2/man3/EVP_PKEY_encrypt
 */
class Evp_PKey_Cipher_Operation extends EVP_Cipher_Operation {
  Evp_PKey_Cipher_Operation() {
    this.(Call).getTarget().getName() in ["EVP_PKEY_encrypt", "EVP_PKEY_decrypt"]
  }

  override Expr getInputArg() { result = this.(Call).getArgument(3) }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }

  override Expr getAlgorithmArg() {
    result = this.getInitCall().(EvpPrimaryAlgorithmInitializer).getAlgorithmArg()
  }
}
