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

import semmle.python.concepts.internal.CryptoAlgorithmNames
import semmle.python.concepts.CryptoAlgorithms
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
  // class CryptographicAlgorithm = CryptoAlgorithms::CryptographicAlgorithm;

  // class EncryptionAlgorithm = CryptoAlgorithms::EncryptionAlgorithm;

  // class HashingAlgorithm = CryptoAlgorithms::HashingAlgorithm;

  // class PasswordHashingAlgorithm = CryptoAlgorithms::PasswordHashingAlgorithm;

  /**
   * A data-flow node that is an application of a cryptographic algorithm. For example,
   * encryption, decryption, signature-validation.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `CryptographicOperation::Range` instead.
   */
  class CryptographicOperation extends DataFlow::Node instanceof CryptographicOperation::Range {
    /** Gets the algorithm used, if it matches a known `CryptographicAlgorithm`. */
    CryptographicAlgorithm getAlgorithm() { 
      result.matchesName(super.getAlgorithmRaw()) or 
      not exists(CryptographicAlgorithm algo | algo.matchesName(super.getAlgorithmRaw())) and result instanceof UnknownAlgorithm }


    /** Gets an input the algorithm is used on, for example the plain text input to be encrypted. */
    DataFlow::Node getAnInput() { result = super.getAnInput() }


    /**
     * Gets the block mode used to perform this cryptographic operation.
     * This may have no result - for example if the `CryptographicAlgorithm` used
     * is a stream cipher rather than a block cipher.
     */
    // TODO: modify to use raw to get unknown, return blockmode unknown (set a blockmode unknown)
    //       make a module blockmode
    //       make getblock mode final, and change all extending to use raw
    final BlockMode getBlockMode() { 
      if isKnownCipherBlockModeAlgorithm(super.getBlockModeRaw()) then
        result = super.getBlockModeRaw()
      else
        result = BlockMode::unknown()
    }

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
      /** Gets the raw algorithm used, i.e., the algorithm extracted directly from the source*/
      abstract string getAlgorithmRaw();


      /** Gets an input the algorithm is used on, for example the plain text input to be encrypted. */
      abstract DataFlow::Node getAnInput();

      /** Gets the raw block mode used, i.e., the block mode extracted directly from the source*/
      abstract string getBlockModeRaw();
    }
  }


  /**
   * A cryptographic block cipher mode of operation. This can be used to encrypt
   * data of arbitrary length using a block encryption algorithm.
   */
  class BlockMode extends string {
    BlockMode() { 
      isKnownCipherBlockModeAlgorithm(this) or 
      (not isKnownCipherBlockModeAlgorithm(this) and this = BlockMode::unknown())
    }

    /** 
     * Holds if this block mode is known and considered to be insecure. 
     * NOTE: if the algorithm is not known, no assessment is made on if it is secure.
     *       Users should use the `isUnknown` predicate specifically to make their 
     *       own assessment in these conditions.  
    */
    predicate isWeak() {
      isWeakCipherBlockModeAlgorithm(this)
    }

    /**
     * Holds if this block mode is not a known block mode
     */
    predicate isUnknown() {
      not isKnownCipherBlockModeAlgorithm(this)
    }
  }

  module BlockMode
  {
    BlockMode unknown()
    {
      result = unknownAlgorithm()
    }
  }
}

/** Provides classes for modeling HTTP-related APIs. */
module Http {
  /** Provides classes for modeling HTTP clients. */
  module Client {
    /**
     * A data-flow node that makes an outgoing HTTP request.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `Http::Client::Request::Range` instead.
     */
    class Request extends DataFlow::Node instanceof Request::Range {
      /**
       * Gets a data-flow node that contributes to the URL of the request.
       * Depending on the framework, a request may have multiple nodes which contribute to the URL.
       */
      DataFlow::Node getAUrlPart() { result = super.getAUrlPart() }

      /** Gets a string that identifies the framework used for this request. */
      string getFramework() { result = super.getFramework() }

      /**
       * Holds if this request is made using a mode that disables SSL/TLS
       * certificate validation, where `disablingNode` represents the point at
       * which the validation was disabled, and `argumentOrigin` represents the origin
       * of the argument that disabled the validation (which could be the same node as
       * `disablingNode`).
       */
      predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        super.disablesCertificateValidation(disablingNode, argumentOrigin)
      }
    }

    /** Provides a class for modeling new HTTP requests. */
    module Request {
      /**
       * A data-flow node that makes an outgoing HTTP request.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `Http::Client::Request` instead.
       */
      abstract class Range extends DataFlow::Node {
        /**
         * Gets a data-flow node that contributes to the URL of the request.
         * Depending on the framework, a request may have multiple nodes which contribute to the URL.
         */
        abstract DataFlow::Node getAUrlPart();

        /** Gets a string that identifies the framework used for this request. */
        abstract string getFramework();

        /**
         * Holds if this request is made using a mode that disables SSL/TLS
         * certificate validation, where `disablingNode` represents the point at
         * which the validation was disabled, and `argumentOrigin` represents the origin
         * of the argument that disabled the validation (which could be the same node as
         * `disablingNode`).
         */
        abstract predicate disablesCertificateValidation(
          DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
        );
      }
    }
  }
}
