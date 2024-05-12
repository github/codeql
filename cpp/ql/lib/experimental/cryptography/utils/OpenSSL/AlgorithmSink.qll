/**
 * Predicates/classes for identifying algorithm sinks.
 * An Algorithm Sink is a function that takes an algorithm as an argument.
 * In particular, any function that takes in an algorithm that until the call
 * the algorithm is not definitely known to be an algorithm (e.g., an integer used as an identifier to fetch an algorithm)
 */

//TODO: enforce a hierarchy of AlgorithmSinkArgument, e.g., so I can get all Asymmetric SinkArguments that includes all the strictly RSA etc.
import cpp
import experimental.cryptography.utils.OpenSSL.LibraryFunction
import experimental.cryptography.CryptoAlgorithmNames

predicate isAlgorithmSink(AlgorithmSinkArgument arg, string algType) { arg.algType() = algType }

abstract class AlgorithmSinkArgument extends Expr {
  AlgorithmSinkArgument() {
    exists(Call c | c.getAnArgument() = this and openSSLLibraryFunc(c.getTarget()))
  }

  /**
   * Gets the function call in which the argument exists
   */
  Call getSinkCall() { result.getAnArgument() = this }

  abstract string algType();
}

// https://www.openssl.org/docs/manmaster/man3/EVP_CIPHER_fetch.html
predicate cipherAlgorithmSink(string funcName, int argInd) {
  funcName in ["EVP_get_cipherbyname", "EVP_get_cipherbynid", "EVP_get_cipherbyobj"] and argInd = 0
  or
  funcName = "EVP_CIPHER_fetch" and argInd = 1
}

class CipherAlgorithmSink extends AlgorithmSinkArgument {
  CipherAlgorithmSink() {
    exists(Call c, string funcName, int argInd |
      funcName = c.getTarget().getName() and this = c.getArgument(argInd)
    |
      cipherAlgorithmSink(funcName, argInd)
    )
  }

  override string algType() { result = getSymmetricEncryptionType() }
}

// https://www.openssl.org/docs/manmaster/man3/EVP_MAC_fetch
predicate macAlgorithmSink(string funcName, int argInd) {
  (funcName = "EVP_MAC_fetch" and argInd = 1)
}

class MACAlgorithmSink extends AlgorithmSinkArgument {
  MACAlgorithmSink() {
    exists(Call c, string funcName, int argInd |
      funcName = c.getTarget().getName() and this = c.getArgument(argInd)
    |
      macAlgorithmSink(funcName, argInd)
    )
  }

  override string algType() { result = "TBD" }
}

// https://www.openssl.org/docs/manmaster/man3/EVP_MD_fetch
predicate messageDigestAlgorithmSink(string funcName, int argInd) {
  funcName in ["EVP_get_digestbyname", "EVP_get_digestbynid", "EVP_get_digestbyobj"] and argInd = 0
  or
  funcName = "EVP_MD_fetch" and argInd = 1
}

class MessageDigestAlgorithmSink extends AlgorithmSinkArgument {
  MessageDigestAlgorithmSink() {
    exists(Call c, string funcName, int argInd |
      funcName = c.getTarget().getName() and this = c.getArgument(argInd)
    |
      messageDigestAlgorithmSink(funcName, argInd)
    )
  }

  override string algType() { result = getHashType() }
}

// https://www.openssl.org/docs/manmaster/man3/EVP_KEYEXCH_fetch
// https://www.openssl.org/docs/manmaster/man3/EVP_KEM_fetch
predicate keyExchangeAlgorithmSink(string funcName, int argInd) {
  funcName = "EVP_KEYEXCH_fetch" and argInd = 1
  or
  funcName = "EVP_KEM_fetch" and argInd = 1
}

class KeyExchangeAlgorithmSink extends AlgorithmSinkArgument {
  KeyExchangeAlgorithmSink() {
    exists(Call c, string funcName, int argInd |
      funcName = c.getTarget().getName() and this = c.getArgument(argInd)
    |
      keyExchangeAlgorithmSink(funcName, argInd)
    )
  }

  override string algType() { result = getKeyExchangeType() }
}

// https://www.openssl.org/docs/manmaster/man3/EVP_KEYMGMT_fetch
predicate keyManagementAlgorithmSink(string funcName, int argInd) {
  funcName = "EVP_KEYMGMT_fetch" and argInd = 1
}

class KeyManagementAlgorithmSink extends AlgorithmSinkArgument {
  KeyManagementAlgorithmSink() {
    exists(Call c, string funcName, int argInd |
      funcName = c.getTarget().getName() and this = c.getArgument(argInd)
    |
      keyManagementAlgorithmSink(funcName, argInd)
    )
  }

  override string algType() { result = "TBD" }
}

// https://www.openssl.org/docs/manmaster/man3/EVP_KDF
predicate keyDerivationAlgorithmSink(string funcName, int argInd) {
  funcName = "EVP_KDF_fetch" and argInd = 1
}

class KeyDerivationAlgorithmSink extends AlgorithmSinkArgument {
  KeyDerivationAlgorithmSink() {
    exists(Call c, string funcName, int argInd |
      funcName = c.getTarget().getName() and this = c.getArgument(argInd)
    |
      keyDerivationAlgorithmSink(funcName, argInd)
    )
  }

  override string algType() { result = getKeyDerivationType() }
}

// https://www.openssl.org/docs/manmaster/man3/EVP_ASYM_CIPHER_fetch
// https://www.openssl.org/docs/manmaster/man3/EVP_PKEY_CTX_new_id
// https://www.openssl.org/docs/manmaster/man3/EVP_PKEY_new_CMAC_key.html
predicate asymmetricCipherAlgorithmSink(string funcName, int argInd) {
  funcName = "EVP_ASYM_CIPHER_fetch" and argInd = 1
  or
  funcName = "EVP_PKEY_new_CMAC_key" and argInd = 3
  // NOTE: other cases are handled by AsymmetricAlgorithmSink
}

class AsymmetricCipherAlgorithmSink extends AlgorithmSinkArgument {
  AsymmetricCipherAlgorithmSink() {
    exists(Call c, string funcName, int argInd |
      funcName = c.getTarget().getName() and this = c.getArgument(argInd)
    |
      asymmetricCipherAlgorithmSink(funcName, argInd)
    )
  }

  override string algType() { result = "ASYMMETRIC_ENCRYPTION" }
}

class AsymmetricCipherAlgorithmSink_EVP_PKEY_Q_keygen extends AlgorithmSinkArgument {
  AsymmetricCipherAlgorithmSink_EVP_PKEY_Q_keygen() {
    exists(Call c, string funcName |
      funcName = c.getTarget().getName() and
      this = c.getArgument(3)
    |
      funcName = "EVP_PKEY_Q_keygen" and
      c.getArgument(3).getType().getUnderlyingType() instanceof IntegralType
    )
  }

  override string algType() { result = "ASYMMETRIC_ENCRYPTION" }
}

// https://www.openssl.org/docs/manmaster/man3/EVP_RAND_fetch
predicate randomAlgorithmSink(string funcName, int argInd) {
  funcName = "EVP_RAND_fetch" and argInd = 1
}

class RandomAlgorithmSink extends AlgorithmSinkArgument {
  RandomAlgorithmSink() {
    exists(Call c, string funcName, int argInd |
      funcName = c.getTarget().getName() and this = c.getArgument(argInd)
    |
      randomAlgorithmSink(funcName, argInd)
    )
  }

  override string algType() { result = "TBD" }
}

// https://www.openssl.org/docs/manmaster/man3/EVP_SIGNATURE_fetch
predicate signatureAlgorithmSink(string funcName, int argInd) {
  funcName = "EVP_SIGNATURE_fetch" and argInd = 1
}

class SignatureAlgorithmSink extends AlgorithmSinkArgument {
  SignatureAlgorithmSink() {
    exists(Call c, string funcName, int argInd |
      funcName = c.getTarget().getName() and this = c.getArgument(argInd)
    |
      signatureAlgorithmSink(funcName, argInd)
    )
  }

  override string algType() { result = getSignatureType() }
}

// https://www.openssl.org/docs/manmaster/man3/EC_KEY_new_by_curve_name.html
// https://www.openssl.org/docs/manmaster/man3/EVP_PKEY_CTX_set_ec_paramgen_curve_nid.html
predicate ellipticCurveAlgorithmSink(string funcName, int argInd) {
  funcName in ["EC_KEY_new_by_curve_name", "EVP_EC_gen"] and argInd = 0
  or
  funcName = "EC_KEY_new_by_curve_name_ex" and argInd = 2
  or
  funcName in ["EVP_PKEY_CTX_set_ec_paramgen_curve_nid"] and argInd = 1
}

class EllipticCurveAlgorithmSink extends AlgorithmSinkArgument {
  EllipticCurveAlgorithmSink() {
    exists(Call c, string funcName, int argInd |
      funcName = c.getTarget().getName() and this = c.getArgument(argInd)
    |
      ellipticCurveAlgorithmSink(funcName, argInd)
    )
  }

  override string algType() { result = getEllipticCurveType() }
}

/**
 * Special cased to address the fact that arg index 3 (zero offset based) is the curve name.
 * ASSUMPTION: if the arg ind 3 is a char* assume it is an elliptic curve
 */
class EllipticCurveAlgorithmSink_EVP_PKEY_Q_keygen extends AlgorithmSinkArgument {
  EllipticCurveAlgorithmSink_EVP_PKEY_Q_keygen() {
    exists(Call c, string funcName |
      funcName = c.getTarget().getName() and
      this = c.getArgument(3)
    |
      funcName = "EVP_PKEY_Q_keygen" and
      c.getArgument(3).getType().getUnderlyingType() instanceof PointerType and
      c.getArgument(3).getType().getUnderlyingType().stripType() instanceof CharType
    )
  }

  override string algType() { result = getEllipticCurveType() }
}

// https://www.openssl.org/docs/manmaster/man3/EVP_PKEY_CTX_new_id.html
// https://www.openssl.org/docs/man1.1.1/man3/EVP_PKEY_new_raw_private_key.html
// https://www.openssl.org/docs/manmaster/man3/EVP_PKEY_new.html
// https://www.openssl.org/docs/manmaster/man3/EVP_PKEY_CTX_ctrl.html
// https://www.openssl.org/docs/manmaster/man3/EVP_PKEY_Q_keygen.html
// https://www.openssl.org/docs/manmaster/man3/EVP_PKEY_CTX_ctrl.html
predicate asymmetricAlgorithmSink(string funcName, int argInd) {
  funcName = "EVP_PKEY_CTX_new_id" and argInd = 0
  or
  funcName = "EVP_PKEY_CTX_new_from_name" and argInd = 1
  or
  funcName in [
      "EVP_PKEY_new_raw_private_key", "EVP_PKEY_new_raw_public_key", "EVP_PKEY_new_mac_key"
    ] and
  argInd = 0
  or
  funcName in ["EVP_PKEY_new_raw_private_key_ex", "EVP_PKEY_new_raw_public_key_ex"] and argInd = 1
  or
  // special casing this as arg index 3 must be specified depending on if RSA or ECC, and otherwise not specified for other algs
  // funcName = "EVP_PKEY_Q_keygen" and argInd = 2
  funcName in ["EVP_PKEY_CTX_ctrl", "EVP_PKEY_CTX_set_group_name"] and argInd = 1
  // TODO consider void cases EVP_PKEY_new
}

class AsymmetricAlgorithmSink extends AlgorithmSinkArgument {
  AsymmetricAlgorithmSink() {
    exists(Call c, string funcName, int argInd |
      funcName = c.getTarget().getName() and this = c.getArgument(argInd)
    |
      asymmetricAlgorithmSink(funcName, argInd)
    )
  }

  override string algType() { result = getAsymmetricType() }
}

class AsymmetricAlgorithmSink_EVP_PKEY_Q_keygen extends AlgorithmSinkArgument {
  AsymmetricAlgorithmSink_EVP_PKEY_Q_keygen() {
    exists(Call c, string funcName |
      funcName = c.getTarget().getName() and
      this = c.getArgument(2)
    |
      funcName = "EVP_PKEY_Q_keygen" and
      not exists(c.getArgument(3))
    )
  }

  override string algType() { result = getAsymmetricType() }
}
