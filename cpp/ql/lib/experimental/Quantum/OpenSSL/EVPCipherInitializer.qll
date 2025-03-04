import experimental.Quantum.Language
import CtxFlow as CTXFlow

module EncValToInitEncArgConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().getValue().toInt() in [0, 1] }

  predicate isSink(DataFlow::Node sink) {
    exists(EVP_Cipher_Inititalizer initCall | sink.asExpr() = initCall.getOperataionSubtypeArg())
  }
}

module EncValToInitEncArgFlow = DataFlow::Global<EncValToInitEncArgConfig>;

int getEncConfigValue(Expr e) {
  exists(EVP_Cipher_Inititalizer initCall | e = initCall.getOperataionSubtypeArg()) and
  exists(DataFlow::Node a, DataFlow::Node b |
    EncValToInitEncArgFlow::flow(a, b) and b.asExpr() = e and result = a.asExpr().getValue().toInt()
  )
}

bindingset[i]
Crypto::CipherOperationSubtype intToCipherOperationSubtype(int i) {
  if i = 0
  then result instanceof Crypto::EncryptionSubtype
  else
    if i = 1
    then result instanceof Crypto::DecryptionSubtype
    else result instanceof Crypto::UnknownCipherOperationSubtype
}

// TODO: need to add key consumer
abstract class EVP_Cipher_Inititalizer extends Call {
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  Expr getAlgorithmArg() { result = this.(Call).getArgument(1) }

  abstract Expr getKeyArg();

  abstract Expr getIVArg();

//   abstract Crypto::CipherOperationSubtype getCipherOperationSubtype();

  abstract Expr getOperataionSubtypeArg();

Crypto::CipherOperationSubtype getCipherOperationSubtype() {
    if this.(Call).getTarget().getName().toLowerCase().matches("%encrypt%")
    then result instanceof Crypto::EncryptionSubtype
    else
      if this.(Call).getTarget().getName().toLowerCase().matches("%decrypt%")
      then result instanceof Crypto::DecryptionSubtype
      else
        if exists(getEncConfigValue(this.getOperataionSubtypeArg()))
        then result = intToCipherOperationSubtype(getEncConfigValue(this.getOperataionSubtypeArg()))
        else result instanceof Crypto::UnknownCipherOperationSubtype
  }
}

abstract class EVP_EX_Initializer extends EVP_Cipher_Inititalizer {
  override Expr getKeyArg() { result = this.(Call).getArgument(3) }

  override Expr getIVArg() { result = this.(Call).getArgument(4) }
}

abstract class EVP_EX2_Initializer extends EVP_Cipher_Inititalizer {
  override Expr getKeyArg() { result = this.(Call).getArgument(2) }

  override Expr getIVArg() { result = this.(Call).getArgument(3) }
}

class EVP_Cipher_EX_Init_Call extends EVP_EX_Initializer {
  EVP_Cipher_EX_Init_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptInit_ex", "EVP_DecryptInit_ex", "EVP_CipherInit_ex"
      ]
  }

  override Expr getOperataionSubtypeArg() {
    this.(Call).getTarget().getName().toLowerCase().matches("%cipherinit%") and
    result = this.(Call).getArgument(5)
  }
}

// abstract class EVP_CipherInit extends EVP_Cipher_Inititalizer{
//     abstract  Expr getOperataionSubtypeArg();
// }
// class EVP_CipherInit_ex_Call extends EVP_EX_Initializer, EVP_CipherInit {
//     EVP_CipherInit_ex_Call() { this.(Call).getTarget().getName() = "EVP_CipherInit_ex" }
//     override Crypto::CipherOperationSubtype getCipherOperationSubtype() {
//       result instanceof Crypto::EncryptionSubtype
//     }
//     override Expr getOperataionSubtypeArg(){
//         result = this.(Call).getArgument(5)
//     }
// }
// class EVP_CipherInit_ex2_Call extends EVP_EX_Initializer, EVP_CipherInit {
//     EVP_CipherInit_ex2_Call() { this.(Call).getTarget().getName() = "EVP_CipherInit_ex2" }
//     override Crypto::CipherOperationSubtype getCipherOperationSubtype() {
//       result instanceof Crypto::EncryptionSubtype
//     }
//     override Expr getOperataionSubtypeArg(){
//         result = this.(Call).getArgument(4)
//     }
// }
class EVP_Cipher_EX2_or_Simple_Init_Call extends EVP_EX2_Initializer {
    EVP_Cipher_EX2_or_Simple_Init_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptInit_ex2", "EVP_DecryptInit_ex2", "EVP_CipherInit_ex2",
        "EVP_EncryptInit", "EVP_DecryptInit", "EVP_CipherInit"
      ]
  }


  override Expr getOperataionSubtypeArg() {
    this.(Call).getTarget().getName().toLowerCase().matches("%cipherinit%") and
    result = this.(Call).getArgument(4)
  }
}

class EVP_CipherInit_SKEY_Call extends EVP_EX2_Initializer {
    EVP_CipherInit_SKEY_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_CipherInit_SKEY"
      ]
  }

  override Expr getOperataionSubtypeArg() {
    result = this.(Call).getArgument(5)
  }
}


// class EVP_CipherInit extends EVP_Cipher_Inititalizer {
//   EVP_CipherInit() { this.(Call).getTarget().getName() = "EVP_CipherInit" }
//   override Expr getKeyArg() { result = this.(Call).getArgument(2) }
//   override Expr getIVArg() { result = this.(Call).getArgument(3) }
//   override Crypto::CipherOperationSubtype getCipherOperationSubtype() {
//     result instanceof Crypto::EncryptionSubtype
//   }
// }
class EVPCipherInitializerAlgorithmArgument extends Expr {
    EVPCipherInitializerAlgorithmArgument() {
    exists(EVP_Cipher_Inititalizer initCall | this = initCall.getAlgorithmArg())
  }
}
class EVPCipherInitializerKeyArgument extends Expr {
    EVPCipherInitializerKeyArgument() {
    exists(EVP_Cipher_Inititalizer initCall | this = initCall.getKeyArg())
  }
}
class EVPCipherInitializerIVArgument extends Expr {
    EVPCipherInitializerIVArgument() { exists(EVP_Cipher_Inititalizer initCall | this = initCall.getIVArg()) }
}

