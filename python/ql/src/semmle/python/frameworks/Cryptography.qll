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
   * Provides helper predicates for the eliptic curve cryptography parts in
   * `cryptography.hazmat.primitives.asymmetric.ec`.
   */
  module Ecc {
    /**
     * Gets a predefined curve class from
     * `cryptography.hazmat.primitives.asymmetric.ec` with a specific key size (in bits).
     */
    private DataFlow::Node curveClassWithKeySize(int keySize) {
      exists(string curveName |
        result =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("asymmetric")
              .getMember("ec")
              .getMember(curveName)
              .getAUse()
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

    /** Gets a reference to a predefined curve class instance with a specific key size (in bits), as well as the origin of the class. */
    private DataFlow::LocalSourceNode curveClassInstanceWithKeySize(
      DataFlow::TypeTracker t, int keySize, DataFlow::Node origin
    ) {
      t.start() and
      result.(DataFlow::CallCfgNode).getFunction() = curveClassWithKeySize(keySize) and
      origin = result
      or
      // Due to bad performance when using normal setup with we have inlined that code and forced a join
      exists(DataFlow::TypeTracker t2 |
        exists(DataFlow::StepSummary summary |
          curveClassInstanceWithKeySize_first_join(t2, keySize, origin, result, summary) and
          t = t2.append(summary)
        )
      )
    }

    pragma[nomagic]
    private predicate curveClassInstanceWithKeySize_first_join(
      DataFlow::TypeTracker t2, int keySize, DataFlow::Node origin, DataFlow::Node res,
      DataFlow::StepSummary summary
    ) {
      DataFlow::StepSummary::step(curveClassInstanceWithKeySize(t2, keySize, origin), res, summary)
    }

    /** Gets a reference to a predefined curve class instance with a specific key size (in bits), as well as the origin of the class. */
    DataFlow::Node curveClassInstanceWithKeySize(int keySize, DataFlow::Node origin) {
      curveClassInstanceWithKeySize(DataFlow::TypeTracker::end(), keySize, origin).flowsTo(result)
    }
  }

  // ---------------------------------------------------------------------------
  /**
   * A call to `cryptography.hazmat.primitives.asymmetric.rsa.generate_private_key`
   *
   * See https://cryptography.io/en/latest/hazmat/primitives/asymmetric/rsa.html#cryptography.hazmat.primitives.asymmetric.rsa.generate_private_key
   */
  class CryptographyRsaGeneratePrivateKeyCall extends Cryptography::PublicKey::KeyGeneration::RsaRange,
    DataFlow::CallCfgNode {
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
    DataFlow::CallCfgNode {
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
    DataFlow::CallCfgNode {
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
      this.getCurveArg() = Ecc::curveClassInstanceWithKeySize(result, origin)
    }

    // Note: There is not really a key-size argument, since it's always specified by the curve.
    override DataFlow::Node getKeySizeArg() { none() }
  }
}
