/**
 * Provides classes modeling security-relevant aspects of
 * - the `pycryptodome` PyPI package (imported as `Crypto`)
 * - the `pycryptodomex` PyPI package (imported as `Cryptodome`)
 * See https://pycryptodome.readthedocs.io/en/latest/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for
 * - the `pycryptodome` PyPI package (imported as `Crypto`)
 * - the `pycryptodomex` PyPI package (imported as `Cryptodome`)
 * See https://pycryptodome.readthedocs.io/en/latest/
 */
private module CryptodomeModel {
  /**
   * A call to `Cryptodome.PublicKey.RSA.generate`/`Crypto.PublicKey.RSA.generate`
   *
   * See https://pycryptodome.readthedocs.io/en/latest/src/public_key/rsa.html#Crypto.PublicKey.RSA.generate
   */
  class CryptodomePublicKeyRsaGenerateCall extends Cryptography::PublicKey::KeyGeneration::RsaRange,
    DataFlow::CallCfgNode
  {
    CryptodomePublicKeyRsaGenerateCall() {
      this =
        API::moduleImport(["Crypto", "Cryptodome"])
            .getMember("PublicKey")
            .getMember("RSA")
            .getMember("generate")
            .getACall()
    }

    override DataFlow::Node getKeySizeArg() {
      result in [this.getArg(0), this.getArgByName("bits")]
    }
  }

  /**
   * A call to `Cryptodome.PublicKey.DSA.generate`/`Crypto.PublicKey.DSA.generate`
   *
   * See https://pycryptodome.readthedocs.io/en/latest/src/public_key/dsa.html#Crypto.PublicKey.DSA.generate
   */
  class CryptodomePublicKeyDsaGenerateCall extends Cryptography::PublicKey::KeyGeneration::DsaRange,
    DataFlow::CallCfgNode
  {
    CryptodomePublicKeyDsaGenerateCall() {
      this =
        API::moduleImport(["Crypto", "Cryptodome"])
            .getMember("PublicKey")
            .getMember("DSA")
            .getMember("generate")
            .getACall()
    }

    override DataFlow::Node getKeySizeArg() {
      result in [this.getArg(0), this.getArgByName("bits")]
    }
  }

  /**
   * A call to `Cryptodome.PublicKey.ECC.generate`/`Crypto.PublicKey.ECC.generate`
   *
   * See https://pycryptodome.readthedocs.io/en/latest/src/public_key/ecc.html#Crypto.PublicKey.ECC.generate
   */
  class CryptodomePublicKeyEccGenerateCall extends Cryptography::PublicKey::KeyGeneration::EccRange,
    DataFlow::CallCfgNode
  {
    CryptodomePublicKeyEccGenerateCall() {
      this =
        API::moduleImport(["Crypto", "Cryptodome"])
            .getMember("PublicKey")
            .getMember("ECC")
            .getMember("generate")
            .getACall()
    }

    /** Gets the argument that specifies the curve to use (a string). */
    DataFlow::Node getCurveArg() { result = this.getArgByName("curve") }

    /** Gets the name of the curve to use, as well as the origin that explains how we obtained this name. */
    string getCurveWithOrigin(DataFlow::Node origin) {
      exists(StringLiteral str | origin = DataFlow::exprNode(str) |
        origin = this.getCurveArg().getALocalSource() and
        result = str.getText()
      )
    }

    override int getKeySizeWithOrigin(DataFlow::Node origin) {
      exists(string curve | curve = this.getCurveWithOrigin(origin) |
        // using list from https://pycryptodome.readthedocs.io/en/latest/src/public_key/ecc.html
        curve in ["NIST P-256", "p256", "P-256", "prime256v1", "secp256r1"] and result = 256
        or
        curve in ["NIST P-384", "p384", "P-384", "prime384v1", "secp384r1"] and result = 384
        or
        curve in ["NIST P-521", "p521", "P-521", "prime521v1", "secp521r1"] and result = 521
      )
    }

    // Note: There is not really a key-size argument, since it's always specified by the curve.
    override DataFlow::Node getKeySizeArg() { none() }
  }

  /**
   * A cryptographic operation on an instance from the `Cipher` subpackage of `Cryptodome`/`Crypto`.
   */
  class CryptodomeGenericCipherOperation extends Cryptography::CryptographicOperation::Range,
    DataFlow::CallCfgNode
  {
    string methodName;
    string cipherName;
    API::CallNode newCall;

    CryptodomeGenericCipherOperation() {
      methodName in [
          "encrypt", "decrypt", "verify", "update", "hexverify", "encrypt_and_digest",
          "decrypt_and_verify"
        ] and
      newCall =
        API::moduleImport(["Crypto", "Cryptodome"])
            .getMember("Cipher")
            .getMember(cipherName)
            .getMember("new")
            .getACall() and
      this = newCall.getReturn().getMember(methodName).getACall()
    }

    override DataFlow::Node getInitialization() { result = newCall }

    override Cryptography::CryptographicAlgorithm getAlgorithm() { result.matchesName(cipherName) }

    override DataFlow::Node getAnInput() {
      methodName = "encrypt" and
      result in [this.getArg(0), this.getArgByName(["message", "plaintext"])]
      or
      methodName = "decrypt" and
      result in [this.getArg(0), this.getArgByName("ciphertext")]
      or
      // for the following methods, method signatures can be found in
      // https://pycryptodome.readthedocs.io/en/latest/src/cipher/modern.html
      methodName = "update" and
      result in [this.getArg(0), this.getArgByName("data")]
      or
      // although `mac_tag` is used as the parameter name in the spec above, some implementations use `received_mac_tag`, for an example, see
      // https://github.com/Legrandin/pycryptodome/blob/5dace638b70ac35bb5d9b565f3e75f7869c9d851/lib/Crypto/Cipher/ChaCha20_Poly1305.py#L207
      methodName = "verify" and
      result in [this.getArg(0), this.getArgByName(["mac_tag", "received_mac_tag"])]
      or
      methodName = "hexverify" and
      result in [this.getArg(0), this.getArgByName("mac_tag_hex")]
      or
      methodName = "encrypt_and_digest" and
      result in [this.getArg(0), this.getArgByName("plaintext")]
      or
      methodName = "decrypt_and_verify" and
      result in [
          this.getArg(0), this.getArgByName("ciphertext"), this.getArg(1),
          this.getArgByName("mac_tag")
        ]
    }

    override Cryptography::BlockMode getBlockMode() {
      // `modeName` is of the form "MODE_<BlockMode>"
      exists(string modeName |
        newCall.getArg(1) =
          API::moduleImport(["Crypto", "Cryptodome"])
              .getMember("Cipher")
              .getMember(cipherName)
              .getMember(modeName)
              .getAValueReachableFromSource()
      |
        result = modeName.splitAt("_", 1)
      )
    }
  }

  /**
   * A cryptographic operation on an instance from the `Signature` subpackage of `Cryptodome`/`Crypto`.
   */
  class CryptodomeGenericSignatureOperation extends Cryptography::CryptographicOperation::Range,
    DataFlow::CallCfgNode
  {
    API::CallNode newCall;
    string methodName;
    string signatureName;

    CryptodomeGenericSignatureOperation() {
      methodName in ["sign", "verify"] and
      newCall =
        API::moduleImport(["Crypto", "Cryptodome"])
            .getMember("Signature")
            .getMember(signatureName)
            .getMember("new")
            .getACall() and
      this = newCall.getReturn().getMember(methodName).getACall()
    }

    override DataFlow::Node getInitialization() { result = newCall }

    override Cryptography::CryptographicAlgorithm getAlgorithm() {
      result.matchesName(signatureName)
    }

    override DataFlow::Node getAnInput() {
      methodName = "sign" and
      result in [this.getArg(0), this.getArgByName("msg_hash")] // Cryptodome.Hash instance
      or
      methodName = "verify" and
      (
        result in [this.getArg(0), this.getArgByName("msg_hash")] // Cryptodome.Hash instance
        or
        result in [this.getArg(1), this.getArgByName("signature")]
      )
    }

    override Cryptography::BlockMode getBlockMode() { none() }
  }

  /**
   * A cryptographic operation on an instance from the `Hash` subpackage of `Cryptodome`/`Crypto`.
   */
  class CryptodomeGenericHashOperation extends Cryptography::CryptographicOperation::Range,
    DataFlow::CallCfgNode
  {
    API::CallNode newCall;
    string hashName;

    CryptodomeGenericHashOperation() {
      exists(API::Node hashModule |
        hashModule =
          API::moduleImport(["Crypto", "Cryptodome"]).getMember("Hash").getMember(hashName) and
        newCall = hashModule.getMember("new").getACall()
      |
        this = newCall
        or
        this = newCall.getReturn().getMember("update").getACall()
      )
    }

    override DataFlow::Node getInitialization() { result = newCall }

    override Cryptography::CryptographicAlgorithm getAlgorithm() { result.matchesName(hashName) }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("data")] }

    override Cryptography::BlockMode getBlockMode() { none() }
  }
}
