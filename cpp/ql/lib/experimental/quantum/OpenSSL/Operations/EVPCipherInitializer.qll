/**
 * see: https://docs.openssl.org/master/man3/EVP_EncryptInit/
 * Models cipher initialization for EVP cipher operations.
 */

private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow as CTXFlow

module EncValToInitEncArgConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().getValue().toInt() in [0, 1] }

  predicate isSink(DataFlow::Node sink) {
    exists(EVP_Cipher_Initializer initCall | sink.asExpr() = initCall.getOperationSubtypeArg())
  }
}

module EncValToInitEncArgFlow = DataFlow::Global<EncValToInitEncArgConfig>;

int getEncConfigValue(Expr e) {
  exists(EVP_Cipher_Initializer initCall | e = initCall.getOperationSubtypeArg()) and
  exists(DataFlow::Node a, DataFlow::Node b |
    EncValToInitEncArgFlow::flow(a, b) and b.asExpr() = e and result = a.asExpr().getValue().toInt()
  )
}

bindingset[i]
Crypto::KeyOperationSubtype intToCipherOperationSubtype(int i) {
  if i = 0
  then result instanceof Crypto::TEncryptMode
  else
    if i = 1
    then result instanceof Crypto::TDecryptMode
    else result instanceof Crypto::TUnknownKeyOperationMode
}

// TODO: need to add key consumer
abstract class EVP_Cipher_Initializer extends Call {
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  Expr getAlgorithmArg() { result = this.(Call).getArgument(1) }

  abstract Expr getKeyArg();

  abstract Expr getIVArg();

  //   abstract Crypto::CipherOperationSubtype getCipherOperationSubtype();
  abstract Expr getOperationSubtypeArg();

  Crypto::KeyOperationSubtype getCipherOperationSubtype() {
    if this.(Call).getTarget().getName().toLowerCase().matches("%encrypt%")
    then result instanceof Crypto::TEncryptMode
    else
      if this.(Call).getTarget().getName().toLowerCase().matches("%decrypt%")
      then result instanceof Crypto::TDecryptMode
      else
        if exists(getEncConfigValue(this.getOperationSubtypeArg()))
        then result = intToCipherOperationSubtype(getEncConfigValue(this.getOperationSubtypeArg()))
        else result instanceof Crypto::TUnknownKeyOperationMode
  }
}

abstract class EVP_EX_Initializer extends EVP_Cipher_Initializer {
  override Expr getKeyArg() { result = this.(Call).getArgument(3) }

  override Expr getIVArg() { result = this.(Call).getArgument(4) }
}

abstract class EVP_EX2_Initializer extends EVP_Cipher_Initializer {
  override Expr getKeyArg() { result = this.(Call).getArgument(2) }

  override Expr getIVArg() { result = this.(Call).getArgument(3) }
}

class EVP_Cipher_EX_Init_Call extends EVP_EX_Initializer {
  EVP_Cipher_EX_Init_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptInit_ex", "EVP_DecryptInit_ex", "EVP_CipherInit_ex"
      ]
  }

  override Expr getOperationSubtypeArg() {
    this.(Call).getTarget().getName().toLowerCase().matches("%cipherinit%") and
    result = this.(Call).getArgument(5)
  }
}

class EVP_Cipher_EX2_or_Simple_Init_Call extends EVP_EX2_Initializer {
  EVP_Cipher_EX2_or_Simple_Init_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptInit_ex2", "EVP_DecryptInit_ex2", "EVP_CipherInit_ex2", "EVP_EncryptInit",
        "EVP_DecryptInit", "EVP_CipherInit"
      ]
  }

  override Expr getOperationSubtypeArg() {
    this.(Call).getTarget().getName().toLowerCase().matches("%cipherinit%") and
    result = this.(Call).getArgument(4)
  }
}

class EVP_CipherInit_SKEY_Call extends EVP_EX2_Initializer {
  EVP_CipherInit_SKEY_Call() { this.(Call).getTarget().getName() in ["EVP_CipherInit_SKEY"] }

  override Expr getOperationSubtypeArg() { result = this.(Call).getArgument(5) }
}

class EVPCipherInitializerAlgorithmArgument extends Expr {
  EVPCipherInitializerAlgorithmArgument() {
    exists(EVP_Cipher_Initializer initCall | this = initCall.getAlgorithmArg())
  }
}

class EVPCipherInitializerKeyArgument extends Expr {
  EVPCipherInitializerKeyArgument() {
    exists(EVP_Cipher_Initializer initCall | this = initCall.getKeyArg())
  }
}

class EVPCipherInitializerIVArgument extends Expr {
  EVPCipherInitializerIVArgument() {
    exists(EVP_Cipher_Initializer initCall | this = initCall.getIVArg())
  }
}
