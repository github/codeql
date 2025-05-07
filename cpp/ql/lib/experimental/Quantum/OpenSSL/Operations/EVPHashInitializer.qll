import cpp

abstract class EVP_Hash_Inititalizer extends Call {
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  abstract Expr getAlgorithmArg();
}

class EVP_DigestInit_Variant_Calls extends EVP_Hash_Inititalizer {
  EVP_DigestInit_Variant_Calls() {
    this.(Call).getTarget().getName() in [
        "EVP_DigestInit", "EVP_DigestInit_ex", "EVP_DigestInit_ex2"
      ]
  }

  override Expr getAlgorithmArg() { result = this.(Call).getArgument(1) }
}
