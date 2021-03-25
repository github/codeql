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
  // ---------------------------------------------------------------------------
  /**
   * A call to `Cryptodome.PublicKey.RSA.generate`/`Crypto.PublicKey.RSA.generate`
   *
   * See https://pycryptodome.readthedocs.io/en/latest/src/public_key/rsa.html#Crypto.PublicKey.RSA.generate
   */
  class CryptodomePublicKeyRsaGenerateCall extends Cryptography::PublicKey::KeyGeneration::RsaRange,
    DataFlow::CallCfgNode {
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
    DataFlow::CallCfgNode {
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
    DataFlow::CallCfgNode {
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
      exists(StrConst str | origin = DataFlow::exprNode(str) |
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
}
