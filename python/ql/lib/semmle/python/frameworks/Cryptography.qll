/**
 * Provides classes modeling security-relevant aspects of the `cryptography` PyPI package.
 * See https://cryptography.io/en/latest/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `cryptography` PyPI package.
 * See https://cryptography.io/en/latest/.
 */
private module CryptographyModel {
  /**
   * Provides helper predicates for the elliptic curve cryptography parts in
   * `cryptography.hazmat.primitives.asymmetric.ec`.
   */
  module Ecc {
    /**
     * Gets a predefined curve class from
     * `cryptography.hazmat.primitives.asymmetric.ec` with a specific key size (in bits).
     */
    API::Node predefinedCurveClass(int keySize) {
      exists(string curveName |
        result =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("asymmetric")
              .getMember("ec")
              .getMember(curveName)
      |
        // obtained by manually looking at source code in
        // https://github.com/pyca/cryptography/blob/cba69f1922803f4f29a3fde01741890d88b8e217/src/cryptography/hazmat/primitives/asymmetric/ec.py#L208-L300
        curveName = "SECT571R1" and keySize = 570 // Indeed the numbers do not match.
        or
        curveName = "SECT409R1" and keySize = 409
        or
        curveName = "SECT283R1" and keySize = 283
        or
        curveName = "SECT233R1" and keySize = 233
        or
        curveName = "SECT163R2" and keySize = 163
        or
        curveName = "SECT571K1" and keySize = 571
        or
        curveName = "SECT409K1" and keySize = 409
        or
        curveName = "SECT283K1" and keySize = 283
        or
        curveName = "SECT233K1" and keySize = 233
        or
        curveName = "SECT163K1" and keySize = 163
        or
        curveName = "SECP521R1" and keySize = 521
        or
        curveName = "SECP384R1" and keySize = 384
        or
        curveName = "SECP256R1" and keySize = 256
        or
        curveName = "SECP256K1" and keySize = 256
        or
        curveName = "SECP224R1" and keySize = 224
        or
        curveName = "SECP192R1" and keySize = 192
        or
        curveName = "BrainpoolP256R1" and keySize = 256
        or
        curveName = "BrainpoolP384R1" and keySize = 384
        or
        curveName = "BrainpoolP512R1" and keySize = 512
      )
    }
  }

  // ---------------------------------------------------------------------------
  /**
   * A call to `cryptography.hazmat.primitives.asymmetric.rsa.generate_private_key`
   *
   * See https://cryptography.io/en/latest/hazmat/primitives/asymmetric/rsa.html#cryptography.hazmat.primitives.asymmetric.rsa.generate_private_key
   */
  class CryptographyRsaGeneratePrivateKeyCall extends Cryptography::PublicKey::KeyGeneration::RsaRange,
    DataFlow::CallCfgNode
  {
    CryptographyRsaGeneratePrivateKeyCall() {
      this =
        API::moduleImport("cryptography")
            .getMember("hazmat")
            .getMember("primitives")
            .getMember("asymmetric")
            .getMember("rsa")
            .getMember("generate_private_key")
            .getACall()
    }

    override DataFlow::Node getKeySizeArg() {
      result in [this.getArg(1), this.getArgByName("key_size")]
    }
  }

  /**
   * A call to `cryptography.hazmat.primitives.asymmetric.dsa.generate_private_key`
   *
   * See https://cryptography.io/en/latest/hazmat/primitives/asymmetric/dsa.html#cryptography.hazmat.primitives.asymmetric.dsa.generate_private_key
   */
  class CryptographyDsaGeneratePrivateKeyCall extends Cryptography::PublicKey::KeyGeneration::DsaRange,
    DataFlow::CallCfgNode
  {
    CryptographyDsaGeneratePrivateKeyCall() {
      this =
        API::moduleImport("cryptography")
            .getMember("hazmat")
            .getMember("primitives")
            .getMember("asymmetric")
            .getMember("dsa")
            .getMember("generate_private_key")
            .getACall()
    }

    override DataFlow::Node getKeySizeArg() {
      result in [this.getArg(0), this.getArgByName("key_size")]
    }
  }

  /**
   * A call to `cryptography.hazmat.primitives.asymmetric.ec.generate_private_key`
   *
   * See https://cryptography.io/en/latest/hazmat/primitives/asymmetric/ec.html#cryptography.hazmat.primitives.asymmetric.ec.generate_private_key
   */
  class CryptographyEcGeneratePrivateKeyCall extends Cryptography::PublicKey::KeyGeneration::EccRange,
    DataFlow::CallCfgNode
  {
    CryptographyEcGeneratePrivateKeyCall() {
      this =
        API::moduleImport("cryptography")
            .getMember("hazmat")
            .getMember("primitives")
            .getMember("asymmetric")
            .getMember("ec")
            .getMember("generate_private_key")
            .getACall()
    }

    /** Gets the argument that specifies the curve to use. */
    DataFlow::Node getCurveArg() { result in [this.getArg(0), this.getArgByName("curve")] }

    override int getKeySizeWithOrigin(DataFlow::Node origin) {
      exists(API::Node n | n = Ecc::predefinedCurveClass(result) and origin = n.asSource() |
        this.getCurveArg() = n.getAValueReachableFromSource()
        or
        this.getCurveArg() = n.getReturn().getAValueReachableFromSource()
      )
    }

    // Note: There is not really a key-size argument, since it's always specified by the curve.
    override DataFlow::Node getKeySizeArg() { none() }
  }

  /** Provides models for the `cryptography.hazmat.primitives.ciphers` package */
  private module Ciphers {
    /** Gets a reference to a `cryptography.hazmat.primitives.ciphers.algorithms` Class */
    API::Node algorithmClassRef(string algorithmName) {
      result =
        API::moduleImport("cryptography")
            .getMember("hazmat")
            .getMember("primitives")
            .getMember("ciphers")
            .getMember("algorithms")
            .getMember(algorithmName)
    }

    /** Gets a reference to a `cryptography.hazmat.primitives.ciphers.modes` Class */
    API::Node modeClassRef(string modeName) {
      result =
        API::moduleImport("cryptography")
            .getMember("hazmat")
            .getMember("primitives")
            .getMember("ciphers")
            .getMember("modes")
            .getMember(modeName)
    }

    /** Gets a reference to a Cipher instance using algorithm with `algorithmName`. */
    API::Node cipherInstance(string algorithmName, string modeName) {
      exists(API::CallNode call | result = call.getReturn() |
        call =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("ciphers")
              .getMember("Cipher")
              .getACall() and
        algorithmClassRef(algorithmName).getReturn().getAValueReachableFromSource() in [
            call.getArg(0), call.getArgByName("algorithm")
          ] and
        exists(DataFlow::Node modeArg | modeArg in [call.getArg(1), call.getArgByName("mode")] |
          if modeArg = modeClassRef(_).getReturn().getAValueReachableFromSource()
          then modeArg = modeClassRef(modeName).getReturn().getAValueReachableFromSource()
          else modeName = "<None or unknown>"
        )
      )
    }

    /**
     * An encrypt or decrypt operation from `cryptography.hazmat.primitives.ciphers`.
     */
    class CryptographyGenericCipherOperation extends Cryptography::CryptographicOperation::Range,
      DataFlow::MethodCallNode
    {
      API::CallNode init;
      string algorithmName;
      string modeName;

      CryptographyGenericCipherOperation() {
        init =
          cipherInstance(algorithmName, modeName).getMember(["decryptor", "encryptor"]).getACall() and
        this = init.getReturn().getMember(["update", "update_into"]).getACall()
      }

      override DataFlow::Node getInitialization() { result = init }

      override Cryptography::CryptographicAlgorithm getAlgorithm() {
        result.matchesName(algorithmName)
      }

      override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("data")] }

      override Cryptography::BlockMode getBlockMode() { result = modeName }
    }
  }

  /** Provides models for the `cryptography.hazmat.primitives.hashes` package */
  private module Hashes {
    /**
     * Gets a reference to a `cryptography.hazmat.primitives.hashes` class, representing
     * a hashing algorithm.
     */
    API::Node algorithmClassRef(string algorithmName) {
      result =
        API::moduleImport("cryptography")
            .getMember("hazmat")
            .getMember("primitives")
            .getMember("hashes")
            .getMember(algorithmName)
    }

    /** Gets a reference to a Hash instance using algorithm with `algorithmName`. */
    private API::CallNode hashInstance(string algorithmName) {
      result =
        API::moduleImport("cryptography")
            .getMember("hazmat")
            .getMember("primitives")
            .getMember("hashes")
            .getMember("Hash")
            .getACall() and
      algorithmClassRef(algorithmName).getReturn().getAValueReachableFromSource() in [
          result.getArg(0), result.getArgByName("algorithm")
        ]
    }

    /**
     * An hashing operation from `cryptography.hazmat.primitives.hashes`.
     */
    class CryptographyGenericHashOperation extends Cryptography::CryptographicOperation::Range,
      DataFlow::MethodCallNode
    {
      API::CallNode init;
      string algorithmName;

      CryptographyGenericHashOperation() {
        init = hashInstance(algorithmName) and
        this = init.getReturn().getMember("update").getACall()
      }

      override DataFlow::Node getInitialization() { result = init }

      override Cryptography::CryptographicAlgorithm getAlgorithm() {
        result.matchesName(algorithmName)
      }

      override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("data")] }

      override Cryptography::BlockMode getBlockMode() { none() }
    }
  }
}
