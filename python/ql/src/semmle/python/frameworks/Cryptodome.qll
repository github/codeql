/**
 * Provides classes modeling security-relevant aspects of
 * - the `pycryptodome` PyPI package (imported as `Crypto`)
 * - the `pycryptodomex` PyPI package (imported as `Cryptodome`)
 * See https://pycryptodome.readthedocs.io/en/latest/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts

/**
 * Provides models for
 * - the `pycryptodome` PyPI package (imported as `Crypto`)
 * - the `pycryptodomex` PyPI package (imported as `Cryptodome`)
 * See https://pycryptodome.readthedocs.io/en/latest/
 */
private module CryptodomeModel {
  // ---------------------------------------------------------------------------
  // Cryptodome
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `Cryptodome` module. */
  private DataFlow::Node cryptodome(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("Cryptodome")
    or
    exists(DataFlow::TypeTracker t2 | result = cryptodome(t2).track(t2, t))
  }

  /** Gets a reference to the `Cryptodome` module. */
  DataFlow::Node cryptodome() { result = cryptodome(DataFlow::TypeTracker::end()) }

  /** Provides models for the `Cryptodome` module. */
  module Cryptodome {
    /**
     * Gets a reference to the attribute `attr_name` of the `Cryptodome` module.
     * WARNING: Only holds for a few predefined attributes.
     */
    private DataFlow::Node cryptodome_attr(DataFlow::TypeTracker t, string attr_name) {
      attr_name in ["PublicKey"] and
      (
        t.start() and
        result = DataFlow::importNode("Cryptodome" + "." + attr_name)
        or
        t.startInAttr(attr_name) and
        result = cryptodome()
      )
      or
      // Due to bad performance when using normal setup with `cryptodome_attr(t2, attr_name).track(t2, t)`
      // we have inlined that code and forced a join
      exists(DataFlow::TypeTracker t2 |
        exists(DataFlow::StepSummary summary |
          cryptodome_attr_first_join(t2, attr_name, result, summary) and
          t = t2.append(summary)
        )
      )
    }

    pragma[nomagic]
    private predicate cryptodome_attr_first_join(
      DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
    ) {
      DataFlow::StepSummary::step(cryptodome_attr(t2, attr_name), res, summary)
    }

    /**
     * Gets a reference to the attribute `attr_name` of the `Cryptodome` module.
     * WARNING: Only holds for a few predefined attributes.
     */
    private DataFlow::Node cryptodome_attr(string attr_name) {
      result = cryptodome_attr(DataFlow::TypeTracker::end(), attr_name)
    }

    // -------------------------------------------------------------------------
    // Cryptodome.PublicKey
    // -------------------------------------------------------------------------
    /** Gets a reference to the `Cryptodome.PublicKey` module. */
    DataFlow::Node publicKey() { result = cryptodome_attr("PublicKey") }

    /** Provides models for the `Cryptodome.PublicKey` module */
    module PublicKey {
      /**
       * Gets a reference to the attribute `attr_name` of the `Cryptodome.PublicKey` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node publicKey_attr(DataFlow::TypeTracker t, string attr_name) {
        attr_name in ["RSA", "DSA", "ECC"] and
        (
          t.start() and
          result = DataFlow::importNode("Cryptodome.PublicKey" + "." + attr_name)
          or
          t.startInAttr(attr_name) and
          result = publicKey()
        )
        or
        // Due to bad performance when using normal setup with `publicKey_attr(t2, attr_name).track(t2, t)`
        // we have inlined that code and forced a join
        exists(DataFlow::TypeTracker t2 |
          exists(DataFlow::StepSummary summary |
            publicKey_attr_first_join(t2, attr_name, result, summary) and
            t = t2.append(summary)
          )
        )
      }

      pragma[nomagic]
      private predicate publicKey_attr_first_join(
        DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
        DataFlow::StepSummary summary
      ) {
        DataFlow::StepSummary::step(publicKey_attr(t2, attr_name), res, summary)
      }

      /**
       * Gets a reference to the attribute `attr_name` of the `Cryptodome.PublicKey` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node publicKey_attr(string attr_name) {
        result = publicKey_attr(DataFlow::TypeTracker::end(), attr_name)
      }

      // -------------------------------------------------------------------------
      // Cryptodome.PublicKey.RSA
      // -------------------------------------------------------------------------
      /** Gets a reference to the `Cryptodome.PublicKey.RSA` module. */
      DataFlow::Node rsa() { result = publicKey_attr("RSA") }

      /** Provides models for the `Cryptodome.PublicKey.RSA` module */
      module RSA {
        /**
         * Gets a reference to the attribute `attr_name` of the `Cryptodome.PublicKey.RSA` module.
         * WARNING: Only holds for a few predefined attributes.
         */
        private DataFlow::Node rsa_attr(DataFlow::TypeTracker t, string attr_name) {
          attr_name in ["generate"] and
          (
            t.start() and
            result = DataFlow::importNode("Cryptodome.PublicKey.RSA" + "." + attr_name)
            or
            t.startInAttr(attr_name) and
            result = rsa()
          )
          or
          // Due to bad performance when using normal setup with `rsa_attr(t2, attr_name).track(t2, t)`
          // we have inlined that code and forced a join
          exists(DataFlow::TypeTracker t2 |
            exists(DataFlow::StepSummary summary |
              rsa_attr_first_join(t2, attr_name, result, summary) and
              t = t2.append(summary)
            )
          )
        }

        pragma[nomagic]
        private predicate rsa_attr_first_join(
          DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
          DataFlow::StepSummary summary
        ) {
          DataFlow::StepSummary::step(rsa_attr(t2, attr_name), res, summary)
        }

        /**
         * Gets a reference to the attribute `attr_name` of the `Cryptodome.PublicKey.RSA` module.
         * WARNING: Only holds for a few predefined attributes.
         */
        private DataFlow::Node rsa_attr(string attr_name) {
          result = rsa_attr(DataFlow::TypeTracker::end(), attr_name)
        }

        /** Gets a reference to the `Cryptodome.PublicKey.RSA.generate` function. */
        DataFlow::Node generate() { result = rsa_attr("generate") }
      }

      // -------------------------------------------------------------------------
      // Cryptodome.PublicKey.DSA
      // -------------------------------------------------------------------------
      /** Gets a reference to the `Cryptodome.PublicKey.DSA` module. */
      DataFlow::Node dsa() { result = publicKey_attr("DSA") }

      /** Provides models for the `Cryptodome.PublicKey.DSA` module */
      module DSA {
        /**
         * Gets a reference to the attribute `attr_name` of the `Cryptodome.PublicKey.DSA` module.
         * WARNING: Only holds for a few predefined attributes.
         */
        private DataFlow::Node dsa_attr(DataFlow::TypeTracker t, string attr_name) {
          attr_name in ["generate"] and
          (
            t.start() and
            result = DataFlow::importNode("Cryptodome.PublicKey.DSA" + "." + attr_name)
            or
            t.startInAttr(attr_name) and
            result = dsa()
          )
          or
          // Due to bad performance when using normal setup with `dsa_attr(t2, attr_name).track(t2, t)`
          // we have inlined that code and forced a join
          exists(DataFlow::TypeTracker t2 |
            exists(DataFlow::StepSummary summary |
              dsa_attr_first_join(t2, attr_name, result, summary) and
              t = t2.append(summary)
            )
          )
        }

        pragma[nomagic]
        private predicate dsa_attr_first_join(
          DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
          DataFlow::StepSummary summary
        ) {
          DataFlow::StepSummary::step(dsa_attr(t2, attr_name), res, summary)
        }

        /**
         * Gets a reference to the attribute `attr_name` of the `Cryptodome.PublicKey.DSA` module.
         * WARNING: Only holds for a few predefined attributes.
         */
        private DataFlow::Node dsa_attr(string attr_name) {
          result = dsa_attr(DataFlow::TypeTracker::end(), attr_name)
        }

        /** Gets a reference to the `Cryptodome.PublicKey.DSA.generate` function. */
        DataFlow::Node generate() { result = dsa_attr("generate") }
      }

      // -------------------------------------------------------------------------
      // Cryptodome.PublicKey.ECC
      // -------------------------------------------------------------------------
      /** Gets a reference to the `Cryptodome.PublicKey.ECC` module. */
      DataFlow::Node ecc() { result = publicKey_attr("ECC") }

      /** Provides models for the `Cryptodome.PublicKey.ECC` module */
      module ECC {
        /**
         * Gets a reference to the attribute `attr_name` of the `Cryptodome.PublicKey.ECC` module.
         * WARNING: Only holds for a few predefined attributes.
         */
        private DataFlow::Node ecc_attr(DataFlow::TypeTracker t, string attr_name) {
          attr_name in ["generate"] and
          (
            t.start() and
            result = DataFlow::importNode("Cryptodome.PublicKey.ECC" + "." + attr_name)
            or
            t.startInAttr(attr_name) and
            result = ecc()
          )
          or
          // Due to bad performance when using normal setup with `ecc_attr(t2, attr_name).track(t2, t)`
          // we have inlined that code and forced a join
          exists(DataFlow::TypeTracker t2 |
            exists(DataFlow::StepSummary summary |
              ecc_attr_first_join(t2, attr_name, result, summary) and
              t = t2.append(summary)
            )
          )
        }

        pragma[nomagic]
        private predicate ecc_attr_first_join(
          DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
          DataFlow::StepSummary summary
        ) {
          DataFlow::StepSummary::step(ecc_attr(t2, attr_name), res, summary)
        }

        /**
         * Gets a reference to the attribute `attr_name` of the `Cryptodome.PublicKey.ECC` module.
         * WARNING: Only holds for a few predefined attributes.
         */
        private DataFlow::Node ecc_attr(string attr_name) {
          result = ecc_attr(DataFlow::TypeTracker::end(), attr_name)
        }

        /** Gets a reference to the `Cryptodome.PublicKey.ECC.generate` function. */
        DataFlow::Node generate() { result = ecc_attr("generate") }
      }
    }
  }

  // ---------------------------------------------------------------------------
  /**
   * A call to `Cryptodome.PublicKey.RSA.generate`
   *
   * See https://pycryptodome.readthedocs.io/en/latest/src/public_key/rsa.html#Crypto.PublicKey.RSA.generate
   */
  class CryptodomePublicKeyRSAGenerateCall extends Cryptography::PublicKey::KeyGeneration::RSARange,
    DataFlow::CfgNode {
    override CallNode node;

    CryptodomePublicKeyRSAGenerateCall() {
      node.getFunction() = Cryptodome::PublicKey::RSA::generate().asCfgNode()
    }

    override DataFlow::Node getKeySizeArg() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("bits")]
    }
  }

  /**
   * A call to `Cryptodome.PublicKey.DSA.generate`
   *
   * See https://pycryptodome.readthedocs.io/en/latest/src/public_key/dsa.html#Crypto.PublicKey.DSA.generate
   */
  class CryptodomePublicKeyDSAGenerateCall extends Cryptography::PublicKey::KeyGeneration::DSARange,
    DataFlow::CfgNode {
    override CallNode node;

    CryptodomePublicKeyDSAGenerateCall() {
      node.getFunction() = Cryptodome::PublicKey::DSA::generate().asCfgNode()
    }

    override DataFlow::Node getKeySizeArg() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("bits")]
    }
  }

  /**
   * A call to `Cryptodome.PublicKey.ECC.generate`
   *
   * See https://pycryptodome.readthedocs.io/en/latest/src/public_key/ecc.html#Crypto.PublicKey.ECC.generate
   */
  class CryptodomePublicKeyEccGenerateCall extends Cryptography::PublicKey::KeyGeneration::ECCRange,
    DataFlow::CfgNode {
    override CallNode node;

    CryptodomePublicKeyEccGenerateCall() {
      node.getFunction() = Cryptodome::PublicKey::ECC::generate().asCfgNode()
    }

    /** Gets the argument that specifies the curve to use (a string). */
    DataFlow::Node getCurveArg() { result.asCfgNode() in [node.getArgByName("curve")] }

    string getCurveWithOrigin(DataFlow::Node origin) {
      exists(StrConst str | origin = DataFlow::exprNode(str) |
        origin.(DataFlow::LocalSourceNode).flowsTo(this.getCurveArg()) and
        result = str.getText()
      )
    }

    override int getKeySizeWithOrigin(DataFlow::Node origin) {
      exists(string curve | curve = getCurveWithOrigin(origin) |
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
