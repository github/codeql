import cpp
private import OpenSSLOperationBase

abstract class EVP_Hash_Initializer extends EVPInitialize { }

class EVP_DigestInit_Variant_Calls extends EVP_Hash_Initializer {
  EVP_DigestInit_Variant_Calls() {
    this.(Call).getTarget().getName() in [
        "EVP_DigestInit", "EVP_DigestInit_ex", "EVP_DigestInit_ex2"
      ]
  }

  override Expr getAlgorithmArg() { result = this.(Call).getArgument(1) }
}
