/**
 * Provides classes for modeling OpenSSL's EVP signature operations
 */

private import experimental.quantum.Language
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.CtxFlow as CTXFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

// TODO: verification

abstract class EVP_Cipher_Initializer extends EVPInitialize {
    Expr keyArg;
    Expr algorithmArg;

    EVP_Cipher_Initializer() {
        this.(Call).getTarget().getName() in [
          "EVP_DigestSignInit", "EVP_DigestSignInit_ex",
          "EVP_SignInit", "EVP_SignInit_ex",
          "EVP_PKEY_sign_init", "EVP_PKEY_sign_init_ex", "EVP_PKEY_sign_init_ex2", "EVP_PKEY_sign_message_init"
        ] and
        (
          this.(Call).getTarget().getName() = "EVP_DigestSignInit" and 
          keyArg = this.(Call).getArgument(5)
          or
          this.(Call).getTarget().getName() = "EVP_DigestSignInit_ex" and 
          keyArg = this.(Call).getArgument(4)
          or
          this.(Call).getTarget().getName() = "EVP_PKEY_sign_init_ex2" and
          algorithmArg = this.(Call).getArgument(1)
          or
          this.(Call).getTarget().getName() = "EVP_PKEY_sign_message_init" and
          algorithmArg = this.(Call).getArgument(1) 
        )
    }

    override Expr getAlgorithmArg() { result = algorithmArg }

    override Expr getKeyArg() { result = keyArg }

    override Expr getIVArg() { none() }

    override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
        if this.(Call).getTarget().getName().toLowerCase().matches("%sign%")
        then result instanceof Crypto::TSignMode
        else
        if this.(Call).getTarget().getName().toLowerCase().matches("%verify%")
        then result instanceof Crypto::TVerifyMode
        else
        result instanceof Crypto::TUnknownKeyOperationMode
    }
}
