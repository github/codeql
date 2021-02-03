/**
 * Provides classes modeling security-relevant aspects of the `cryptography` PyPI package.
 * See https://cryptography.io/en/latest/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts

/**
 * Provides models for the `cryptography` PyPI package.
 * See https://cryptography.io/en/latest/.
 */
private module CryptographyModel {
  // ---------------------------------------------------------------------------
  // cryptography
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `cryptography` module. */
  private DataFlow::Node cryptography(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("cryptography")
    or
    exists(DataFlow::TypeTracker t2 | result = cryptography(t2).track(t2, t))
  }

  /** Gets a reference to the `cryptography` module. */
  DataFlow::Node cryptography() { result = cryptography(DataFlow::TypeTracker::end()) }

  /** Provides models for the `cryptography` module. */
  module cryptography {
    /**
     * Gets a reference to the attribute `attr_name` of the `cryptography` module.
     * WARNING: Only holds for a few predefined attributes.
     */
    private DataFlow::Node cryptography_attr(DataFlow::TypeTracker t, string attr_name) {
      attr_name in ["hazmat"] and
      (
        t.start() and
        result = DataFlow::importNode("cryptography" + "." + attr_name)
        or
        t.startInAttr(attr_name) and
        result = cryptography()
      )
      or
      // Due to bad performance when using normal setup with `cryptography_attr(t2, attr_name).track(t2, t)`
      // we have inlined that code and forced a join
      exists(DataFlow::TypeTracker t2 |
        exists(DataFlow::StepSummary summary |
          cryptography_attr_first_join(t2, attr_name, result, summary) and
          t = t2.append(summary)
        )
      )
    }

    pragma[nomagic]
    private predicate cryptography_attr_first_join(
      DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
    ) {
      DataFlow::StepSummary::step(cryptography_attr(t2, attr_name), res, summary)
    }

    /**
     * Gets a reference to the attribute `attr_name` of the `cryptography` module.
     * WARNING: Only holds for a few predefined attributes.
     */
    private DataFlow::Node cryptography_attr(string attr_name) {
      result = cryptography_attr(DataFlow::TypeTracker::end(), attr_name)
    }

    // -------------------------------------------------------------------------
    // cryptography.hazmat
    // -------------------------------------------------------------------------
    /** Gets a reference to the `cryptography.hazmat` module. */
    DataFlow::Node hazmat() { result = cryptography_attr("hazmat") }

    /** Provides models for the `cryptography.hazmat` module */
    module hazmat {
      /**
       * Gets a reference to the attribute `attr_name` of the `cryptography.hazmat` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node hazmat_attr(DataFlow::TypeTracker t, string attr_name) {
        attr_name in ["primitives"] and
        (
          t.start() and
          result = DataFlow::importNode("cryptography.hazmat" + "." + attr_name)
          or
          t.startInAttr(attr_name) and
          result = hazmat()
        )
        or
        // Due to bad performance when using normal setup with `hazmat_attr(t2, attr_name).track(t2, t)`
        // we have inlined that code and forced a join
        exists(DataFlow::TypeTracker t2 |
          exists(DataFlow::StepSummary summary |
            hazmat_attr_first_join(t2, attr_name, result, summary) and
            t = t2.append(summary)
          )
        )
      }

      pragma[nomagic]
      private predicate hazmat_attr_first_join(
        DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
        DataFlow::StepSummary summary
      ) {
        DataFlow::StepSummary::step(hazmat_attr(t2, attr_name), res, summary)
      }

      /**
       * Gets a reference to the attribute `attr_name` of the `cryptography.hazmat` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node hazmat_attr(string attr_name) {
        result = hazmat_attr(DataFlow::TypeTracker::end(), attr_name)
      }

      // -------------------------------------------------------------------------
      // cryptography.hazmat.primitives
      // -------------------------------------------------------------------------
      /** Gets a reference to the `cryptography.hazmat.primitives` module. */
      DataFlow::Node primitives() { result = hazmat_attr("primitives") }

      /** Provides models for the `cryptography.hazmat.primitives` module */
      module primitives {
        /**
         * Gets a reference to the attribute `attr_name` of the `cryptography.hazmat.primitives` module.
         * WARNING: Only holds for a few predefined attributes.
         */
        private DataFlow::Node primitives_attr(DataFlow::TypeTracker t, string attr_name) {
          attr_name in ["asymmetric"] and
          (
            t.start() and
            result = DataFlow::importNode("cryptography.hazmat.primitives" + "." + attr_name)
            or
            t.startInAttr(attr_name) and
            result = primitives()
          )
          or
          // Due to bad performance when using normal setup with `primitives_attr(t2, attr_name).track(t2, t)`
          // we have inlined that code and forced a join
          exists(DataFlow::TypeTracker t2 |
            exists(DataFlow::StepSummary summary |
              primitives_attr_first_join(t2, attr_name, result, summary) and
              t = t2.append(summary)
            )
          )
        }

        pragma[nomagic]
        private predicate primitives_attr_first_join(
          DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
          DataFlow::StepSummary summary
        ) {
          DataFlow::StepSummary::step(primitives_attr(t2, attr_name), res, summary)
        }

        /**
         * Gets a reference to the attribute `attr_name` of the `cryptography.hazmat.primitives` module.
         * WARNING: Only holds for a few predefined attributes.
         */
        private DataFlow::Node primitives_attr(string attr_name) {
          result = primitives_attr(DataFlow::TypeTracker::end(), attr_name)
        }

        // -------------------------------------------------------------------------
        // cryptography.hazmat.primitives.asymmetric
        // -------------------------------------------------------------------------
        /** Gets a reference to the `cryptography.hazmat.primitives.asymmetric` module. */
        DataFlow::Node asymmetric() { result = primitives_attr("asymmetric") }

        /** Provides models for the `cryptography.hazmat.primitives.asymmetric` module */
        module asymmetric {
          /**
           * Gets a reference to the attribute `attr_name` of the `cryptography.hazmat.primitives.asymmetric` module.
           * WARNING: Only holds for a few predefined attributes.
           */
          private DataFlow::Node asymmetric_attr(DataFlow::TypeTracker t, string attr_name) {
            attr_name in ["rsa", "dsa", "ec"] and
            (
              t.start() and
              result =
                DataFlow::importNode("cryptography.hazmat.primitives.asymmetric" + "." + attr_name)
              or
              t.startInAttr(attr_name) and
              result = asymmetric()
            )
            or
            // Due to bad performance when using normal setup with `asymmetric_attr(t2, attr_name).track(t2, t)`
            // we have inlined that code and forced a join
            exists(DataFlow::TypeTracker t2 |
              exists(DataFlow::StepSummary summary |
                asymmetric_attr_first_join(t2, attr_name, result, summary) and
                t = t2.append(summary)
              )
            )
          }

          pragma[nomagic]
          private predicate asymmetric_attr_first_join(
            DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
            DataFlow::StepSummary summary
          ) {
            DataFlow::StepSummary::step(asymmetric_attr(t2, attr_name), res, summary)
          }

          /**
           * Gets a reference to the attribute `attr_name` of the `cryptography.hazmat.primitives.asymmetric` module.
           * WARNING: Only holds for a few predefined attributes.
           */
          private DataFlow::Node asymmetric_attr(string attr_name) {
            result = asymmetric_attr(DataFlow::TypeTracker::end(), attr_name)
          }

          // -------------------------------------------------------------------------
          // cryptography.hazmat.primitives.asymmetric.rsa
          // -------------------------------------------------------------------------
          /** Gets a reference to the `cryptography.hazmat.primitives.asymmetric.rsa` module. */
          DataFlow::Node rsa() { result = asymmetric_attr("rsa") }

          /** Provides models for the `cryptography.hazmat.primitives.asymmetric.rsa` module */
          module rsa {
            /**
             * Gets a reference to the attribute `attr_name` of the `cryptography.hazmat.primitives.asymmetric.rsa` module.
             * WARNING: Only holds for a few predefined attributes.
             */
            private DataFlow::Node rsa_attr(DataFlow::TypeTracker t, string attr_name) {
              attr_name in ["generate_private_key"] and
              (
                t.start() and
                result =
                  DataFlow::importNode("cryptography.hazmat.primitives.asymmetric.rsa" + "." +
                      attr_name)
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
             * Gets a reference to the attribute `attr_name` of the `cryptography.hazmat.primitives.asymmetric.rsa` module.
             * WARNING: Only holds for a few predefined attributes.
             */
            private DataFlow::Node rsa_attr(string attr_name) {
              result = rsa_attr(DataFlow::TypeTracker::end(), attr_name)
            }

            /** Gets a reference to the `cryptography.hazmat.primitives.asymmetric.rsa.generate_private_key` function. */
            DataFlow::Node generate_private_key() { result = rsa_attr("generate_private_key") }
          }

          // -------------------------------------------------------------------------
          // cryptography.hazmat.primitives.asymmetric.dsa
          // -------------------------------------------------------------------------
          /** Gets a reference to the `cryptography.hazmat.primitives.asymmetric.dsa` module. */
          DataFlow::Node dsa() { result = asymmetric_attr("dsa") }

          /** Provides models for the `cryptography.hazmat.primitives.asymmetric.dsa` module */
          module dsa {
            /**
             * Gets a reference to the attribute `attr_name` of the `cryptography.hazmat.primitives.asymmetric.dsa` module.
             * WARNING: Only holds for a few predefined attributes.
             */
            private DataFlow::Node dsa_attr(DataFlow::TypeTracker t, string attr_name) {
              attr_name in ["generate_private_key"] and
              (
                t.start() and
                result =
                  DataFlow::importNode("cryptography.hazmat.primitives.asymmetric.dsa" + "." +
                      attr_name)
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
             * Gets a reference to the attribute `attr_name` of the `cryptography.hazmat.primitives.asymmetric.dsa` module.
             * WARNING: Only holds for a few predefined attributes.
             */
            private DataFlow::Node dsa_attr(string attr_name) {
              result = dsa_attr(DataFlow::TypeTracker::end(), attr_name)
            }

            /** Gets a reference to the `cryptography.hazmat.primitives.asymmetric.dsa.generate_private_key` function. */
            DataFlow::Node generate_private_key() { result = dsa_attr("generate_private_key") }
          }

          // -------------------------------------------------------------------------
          // cryptography.hazmat.primitives.asymmetric.ec
          // -------------------------------------------------------------------------
          /** Gets a reference to the `cryptography.hazmat.primitives.asymmetric.ec` module. */
          DataFlow::Node ec() { result = asymmetric_attr("ec") }

          /** Provides models for the `cryptography.hazmat.primitives.asymmetric.ec` module */
          module ec {
            /**
             * Gets a reference to the attribute `attr_name` of the `cryptography.hazmat.primitives.asymmetric.ec` module.
             * WARNING: Only holds for a few predefined attributes.
             */
            private DataFlow::Node ec_attr(DataFlow::TypeTracker t, string attr_name) {
              attr_name in [
                  "generate_private_key",
                  // curves
                  "SECT571R1", "SECT409R1", "SECT283R1", "SECT233R1", "SECT163R2", "SECT571K1",
                  "SECT409K1", "SECT283K1", "SECT233K1", "SECT163K1", "SECP521R1", "SECP384R1",
                  "SECP256R1", "SECP256K1", "SECP224R1", "SECP192R1", "BrainpoolP256R1",
                  "BrainpoolP384R1", "BrainpoolP512R1"
                ] and
              (
                t.start() and
                result =
                  DataFlow::importNode("cryptography.hazmat.primitives.asymmetric.ec" + "." +
                      attr_name)
                or
                t.startInAttr(attr_name) and
                result = ec()
              )
              or
              // Due to bad performance when using normal setup with `ec_attr(t2, attr_name).track(t2, t)`
              // we have inlined that code and forced a join
              exists(DataFlow::TypeTracker t2 |
                exists(DataFlow::StepSummary summary |
                  ec_attr_first_join(t2, attr_name, result, summary) and
                  t = t2.append(summary)
                )
              )
            }

            pragma[nomagic]
            private predicate ec_attr_first_join(
              DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
              DataFlow::StepSummary summary
            ) {
              DataFlow::StepSummary::step(ec_attr(t2, attr_name), res, summary)
            }

            /**
             * Gets a reference to the attribute `attr_name` of the `cryptography.hazmat.primitives.asymmetric.ec` module.
             * WARNING: Only holds for a few predefined attributes.
             */
            private DataFlow::Node ec_attr(string attr_name) {
              result = ec_attr(DataFlow::TypeTracker::end(), attr_name)
            }

            /** Gets a reference to the `cryptography.hazmat.primitives.asymmetric.ec.generate_private_key` function. */
            DataFlow::Node generate_private_key() { result = ec_attr("generate_private_key") }

            /** Gets a predefined curve class with a specific key size (in bits). */
            DataFlow::Node curveClassWithKeySize(int keySize) {
              // obtained by manually looking at source code in
              // https://github.com/pyca/cryptography/blob/cba69f1922803f4f29a3fde01741890d88b8e217/src/cryptography/hazmat/primitives/asymmetric/ec.py#L208-L300
              result = ec_attr("SECT571R1") and keySize = 570
              or
              result = ec_attr("SECT409R1") and keySize = 409
              or
              result = ec_attr("SECT283R1") and keySize = 283
              or
              result = ec_attr("SECT233R1") and keySize = 233
              or
              result = ec_attr("SECT163R2") and keySize = 163
              or
              result = ec_attr("SECT571K1") and keySize = 571
              or
              result = ec_attr("SECT409K1") and keySize = 409
              or
              result = ec_attr("SECT283K1") and keySize = 283
              or
              result = ec_attr("SECT233K1") and keySize = 233
              or
              result = ec_attr("SECT163K1") and keySize = 163
              or
              result = ec_attr("SECP521R1") and keySize = 521
              or
              result = ec_attr("SECP384R1") and keySize = 384
              or
              result = ec_attr("SECP256R1") and keySize = 256
              or
              result = ec_attr("SECP256K1") and keySize = 256
              or
              result = ec_attr("SECP224R1") and keySize = 224
              or
              result = ec_attr("SECP192R1") and keySize = 192
              or
              result = ec_attr("BrainpoolP256R1") and keySize = 256
              or
              result = ec_attr("BrainpoolP384R1") and keySize = 384
              or
              result = ec_attr("BrainpoolP512R1") and keySize = 512
            }

            /** Gets a reference to a predefined curve class instance with a specific key size (in bits), as well as the origin of the class. */
            private DataFlow::Node curveClassInstanceWithKeySize(
              DataFlow::TypeTracker t, int keySize, DataFlow::Node origin
            ) {
              t.start() and
              result.asCfgNode().(CallNode).getFunction() =
                curveClassWithKeySize(keySize).asCfgNode() and
              origin = result
              or
              exists(DataFlow::TypeTracker t2 |
                result = curveClassInstanceWithKeySize(t2, keySize, origin).track(t2, t)
              )
            }

            /** Gets a reference to a predefined curve class instance with a specific key size (in bits), as well as the origin of the class. */
            DataFlow::Node curveClassInstanceWithKeySize(int keySize, DataFlow::Node origin) {
              result = curveClassInstanceWithKeySize(DataFlow::TypeTracker::end(), keySize, origin)
            }
          }
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  /**
   * A call to `cryptography.hazmat.primitives.asymmetric.rsa.generate_private_key`
   *
   * See https://cryptography.io/en/latest/hazmat/primitives/asymmetric/rsa.html#cryptography.hazmat.primitives.asymmetric.rsa.generate_private_key
   */
  class CryptographyRsaGeneratePrivateKeyCall extends Cryptography::PublicKey::KeyGeneration::RsaRange,
    DataFlow::CfgNode {
    override CallNode node;

    CryptographyRsaGeneratePrivateKeyCall() {
      node.getFunction() =
        cryptography::hazmat::primitives::asymmetric::rsa::generate_private_key().asCfgNode()
    }

    override DataFlow::Node getKeySizeArg() {
      result.asCfgNode() in [node.getArg(1), node.getArgByName("key_size")]
    }
  }

  /**
   * A call to `cryptography.hazmat.primitives.asymmetric.dsa.generate_private_key`
   *
   * See https://cryptography.io/en/latest/hazmat/primitives/asymmetric/dsa.html#cryptography.hazmat.primitives.asymmetric.dsa.generate_private_key
   */
  class CryptographyDsaGeneratePrivateKeyCall extends Cryptography::PublicKey::KeyGeneration::DsaRange,
    DataFlow::CfgNode {
    override CallNode node;

    CryptographyDsaGeneratePrivateKeyCall() {
      node.getFunction() =
        cryptography::hazmat::primitives::asymmetric::dsa::generate_private_key().asCfgNode()
    }

    override DataFlow::Node getKeySizeArg() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("key_size")]
    }
  }

  /**
   * A call to `cryptography.hazmat.primitives.asymmetric.ec.generate_private_key`
   *
   * See https://cryptography.io/en/latest/hazmat/primitives/asymmetric/ec.html#cryptography.hazmat.primitives.asymmetric.ec.generate_private_key
   */
  class CryptographyEcGeneratePrivateKeyCall extends Cryptography::PublicKey::KeyGeneration::EccRange,
    DataFlow::CfgNode {
    override CallNode node;

    CryptographyEcGeneratePrivateKeyCall() {
      node.getFunction() =
        cryptography::hazmat::primitives::asymmetric::ec::generate_private_key().asCfgNode()
    }

    /** Gets the argument that specifies the curve to use. */
    DataFlow::Node getCurveArg() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("curve")]
    }

    override int getKeySizeWithOrigin(DataFlow::Node origin) {
      this.getCurveArg() =
        cryptography::hazmat::primitives::asymmetric::ec::curveClassInstanceWithKeySize(result,
          origin)
    }

    // Note: There is not really a key-size argument, since it's always specified by the curve.
    override DataFlow::Node getKeySizeArg() { none() }
  }
}
