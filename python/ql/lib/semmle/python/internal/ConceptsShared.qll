/**
 * Provides Concepts which are shared across languages.
 *
 * Each language has a language specific `Concepts.qll` file that can import the
 * shared concepts from this file. A language can either re-export the concept directly,
 * or can add additional member-predicates that are needed for that language.
 *
 * Moving forward, `Concepts.qll` will be the staging ground for brand new concepts from
 * each language, but we will maintain a discipline of moving those concepts to
 * `ConceptsShared.qll` ASAP.
 */

private import ConceptsImports

/**
 * Provides models for cryptographic concepts.
 *
 * Note: The `CryptographicAlgorithm` class currently doesn't take weak keys into
 * consideration for the `isWeak` member predicate. So RSA is always considered
 * secure, although using a low number of bits will actually make it insecure. We plan
 * to improve our libraries in the future to more precisely capture this aspect.
 */
module Cryptography {
  class CryptographicAlgorithm = CryptoAlgorithms::CryptographicAlgorithm;

  class EncryptionAlgorithm = CryptoAlgorithms::EncryptionAlgorithm;

  class HashingAlgorithm = CryptoAlgorithms::HashingAlgorithm;

  class PasswordHashingAlgorithm = CryptoAlgorithms::PasswordHashingAlgorithm;

  /**
   * A data-flow node that is an application of a cryptographic algorithm. For example,
   * encryption, decryption, signature-validation.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `CryptographicOperation::Range` instead.
   */
  class CryptographicOperation extends DataFlow::Node instanceof CryptographicOperation::Range {
    /** Gets the algorithm used, if it matches a known `CryptographicAlgorithm`. */
    CryptographicAlgorithm getAlgorithm() { result = super.getAlgorithm() }

    /** Gets an input the algorithm is used on, for example the plain text input to be encrypted. */
    DataFlow::Node getAnInput() { result = super.getAnInput() }

    /**
     * Gets the block mode used to perform this cryptographic operation.
     * This may have no result - for example if the `CryptographicAlgorithm` used
     * is a stream cipher rather than a block cipher.
     */
    BlockMode getBlockMode() { result = super.getBlockMode() }
  }

  /** Provides classes for modeling new applications of a cryptographic algorithms. */
  module CryptographicOperation {
    /**
     * A data-flow node that is an application of a cryptographic algorithm. For example,
     * encryption, decryption, signature-validation.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `CryptographicOperation` instead.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets the algorithm used, if it matches a known `CryptographicAlgorithm`. */
      abstract CryptographicAlgorithm getAlgorithm();

      /** Gets an input the algorithm is used on, for example the plain text input to be encrypted. */
      abstract DataFlow::Node getAnInput();

      /**
       * Gets the block mode used to perform this cryptographic operation.
       * This may have no result - for example if the `CryptographicAlgorithm` used
       * is a stream cipher rather than a block cipher.
       */
      abstract BlockMode getBlockMode();
    }
  }

  /**
   * A cryptographic block cipher mode of operation. This can be used to encrypt
   * data of arbitrary length using a block encryption algorithm.
   */
  class BlockMode extends string {
    BlockMode() { this = ["ECB", "CBC", "GCM", "CCM", "CFB", "OFB", "CTR", "OPENPGP"] }

    /** Holds if this block mode is considered to be insecure. */
    predicate isWeak() { this = "ECB" }
  }
}
