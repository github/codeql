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
overlay[local?]
module;

private import CryptoAlgorithms as CA
private import codeql.dataflow.DataFlow as DF
private import codeql.util.Location

/**
 * Construct the shared concepts modules.
 */
module ConceptsMake<LocationSig Location, DF::InputSig<Location> DataFlowLang> {
  final private class DataFlowNode = DataFlowLang::Node;

  /**
   * Provides models for cryptographic concepts.
   *
   * Note: The `CryptographicAlgorithm` class currently doesn't take weak keys into
   * consideration for the `isWeak` member predicate. So RSA is always considered
   * secure, although using a low number of bits will actually make it insecure. We plan
   * to improve our libraries in the future to more precisely capture this aspect.
   */
  module Cryptography {
    class CryptographicAlgorithm = CA::CryptographicAlgorithm;

    class EncryptionAlgorithm = CA::EncryptionAlgorithm;

    class HashingAlgorithm = CA::HashingAlgorithm;

    class PasswordHashingAlgorithm = CA::PasswordHashingAlgorithm;

    /**
     * A data flow node that is an application of a cryptographic algorithm. For example,
     * encryption, decryption, signature-validation.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `CryptographicOperation::Range` instead.
     */
    class CryptographicOperation extends DataFlowNode instanceof CryptographicOperation::Range {
      /** Gets the algorithm used, if it matches a known `CryptographicAlgorithm`. */
      CryptographicAlgorithm getAlgorithm() { result = super.getAlgorithm() }

      /** Gets the data flow node where the cryptographic algorithm used in this operation is configured. */
      DataFlowNode getInitialization() { result = super.getInitialization() }

      /** Gets an input the algorithm is used on, for example the plain text input to be encrypted. */
      DataFlowNode getAnInput() { result = super.getAnInput() }

      /**
       * Gets the block mode used to perform this cryptographic operation.
       *
       * This predicate is only expected to have a result if two conditions hold:
       *  1. The operation is an encryption operation, i.e. the algorithm used is an `EncryptionAlgorithm`, and
       *  2. The algorithm used is a block cipher (not a stream cipher).
       *
       * If either of these conditions do not hold, then this predicate should have no result.
       */
      BlockMode getBlockMode() { result = super.getBlockMode() }
    }

    /** Provides classes for modeling new applications of a cryptographic algorithms. */
    module CryptographicOperation {
      /**
       * A data flow node that is an application of a cryptographic algorithm. For example,
       * encryption, decryption, signature-validation.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `CryptographicOperation` instead.
       */
      abstract class Range extends DataFlowNode {
        /** Gets the data flow node where the cryptographic algorithm used in this operation is configured. */
        abstract DataFlowNode getInitialization();

        /** Gets the algorithm used, if it matches a known `CryptographicAlgorithm`. */
        abstract CryptographicAlgorithm getAlgorithm();

        /** Gets an input the algorithm is used on, for example the plain text input to be encrypted. */
        abstract DataFlowNode getAnInput();

        /**
         * Gets the block mode used to perform this cryptographic operation.
         *
         * This predicate is only expected to have a result if two conditions hold:
         *  1. The operation is an encryption operation, i.e. the algorithm used is an `EncryptionAlgorithm`, and
         *  2. The algorithm used is a block cipher (not a stream cipher).
         *
         * If either of these conditions do not hold, then this predicate should have no result.
         */
        abstract BlockMode getBlockMode();
      }
    }

    /**
     * A cryptographic block cipher mode of operation. This can be used to encrypt
     * data of arbitrary length using a block encryption algorithm.
     */
    class BlockMode extends string {
      BlockMode() {
        this =
          [
            "ECB", "CBC", "GCM", "CCM", "CFB", "OFB", "CTR", "OPENPGP",
            "XTS", // https://csrc.nist.gov/publications/detail/sp/800-38e/final
            "EAX" // https://en.wikipedia.org/wiki/EAX_mode
          ]
      }

      /** Holds if this block mode is considered to be insecure. */
      predicate isWeak() { this = "ECB" }

      /** Holds if the given string appears to match this block mode. */
      bindingset[s]
      predicate matchesString(string s) { s.toUpperCase().matches("%" + this + "%") }
    }
  }

  /** Provides classes for modeling HTTP-related APIs. */
  module Http {
    /** Provides classes for modeling HTTP clients. */
    module Client {
      /**
       * A data flow node that makes an outgoing HTTP request.
       *
       * Extend this class to refine existing API models. If you want to model new APIs,
       * extend `Http::Client::Request::Range` instead.
       */
      class Request extends DataFlowNode instanceof Request::Range {
        /**
         * Gets a data flow node that contributes to the URL of the request.
         * Depending on the framework, a request may have multiple nodes which contribute to the URL.
         */
        DataFlowNode getAUrlPart() { result = super.getAUrlPart() }

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
          DataFlowNode disablingNode, DataFlowNode argumentOrigin
        ) {
          super.disablesCertificateValidation(disablingNode, argumentOrigin)
        }
      }

      /** Provides a class for modeling new HTTP requests. */
      module Request {
        /**
         * A data flow node that makes an outgoing HTTP request.
         *
         * Extend this class to model new APIs. If you want to refine existing API models,
         * extend `Http::Client::Request` instead.
         */
        abstract class Range extends DataFlowNode {
          /**
           * Gets a data flow node that contributes to the URL of the request.
           * Depending on the framework, a request may have multiple nodes which contribute to the URL.
           */
          abstract DataFlowNode getAUrlPart();

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
            DataFlowNode disablingNode, DataFlowNode argumentOrigin
          );
        }
      }
    }
  }
}
