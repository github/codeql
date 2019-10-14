/**
 * This module has classes and data flow configuration for working with symmetric encryption keys data flow.
 */

import csharp

module EncryptionKeyDataFlow {
  private import SymmetricAlgorithm

  /** Array of type Byte */
  class ByteArray extends ArrayType {
    ByteArray() { getElementType() instanceof ByteType }
  }

  /** Abstract class for all sources of keys */
  abstract class KeySource extends DataFlow::Node { }

  /**
   * A symmetric encryption sink is abstract base class for all ways to set a key for symmetric encryption.
   */
  abstract class SymmetricEncryptionKeySink extends DataFlow::Node {
    /** override to create a meaningful description of the sink */
    abstract string getDescription();
  }

  /**
   * A sanitizer for symmetric encryption key. If present, for example, key is properly constructed or retrieved from secret storage.
   */
  abstract class KeySanitizer extends DataFlow::ExprNode { }

  /**
   * Symmetric Algorithm, 'Key' property assigned a value
   */
  class SymmetricEncryptionKeyPropertySink extends SymmetricEncryptionKeySink {
    SymmetricEncryptionKeyPropertySink() {
      exists(SymmetricAlgorithm ag | asExpr() = ag.getKeyProperty().getAnAssignedValue())
    }

    string getDescription() { result = "Key property assignment" }
  }

  /**
   * Symmetric Algorithm, CreateEncryptor method, rgbKey parameter
   */
  class SymmetricEncryptionCreateEncryptorSink extends SymmetricEncryptionKeySink {
    SymmetricEncryptionCreateEncryptorSink() {
      exists(SymmetricAlgorithm ag, MethodCall mc, Variable v | mc = ag.getASymmetricEncryptor(v) |
        asExpr() = mc.getArgumentForName("rgbKey")
      )
    }

    string getDescription() { result = "Encryptor(rgbKey, IV)" }
  }

  /**
   * Symmetric Algorithm, CreateDecryptor method, rgbKey parameter
   */
  class SymmetricEncryptionCreateDecryptorSink extends SymmetricEncryptionKeySink {
    SymmetricEncryptionCreateDecryptorSink() {
      exists(SymmetricAlgorithm ag, MethodCall mc, Variable v | mc = ag.getASymmetricDecryptor(v) |
        asExpr() = mc.getArgumentForName("rgbKey")
      )
    }

    string getDescription() { result = "Decryptor(rgbKey, IV)" }
  }

  /**
   * Symmetric Key Data Flow configuration.
   */
  class SymmetricKeyTaintTrackingConfiguration extends TaintTracking::Configuration {
    SymmetricKeyTaintTrackingConfiguration() { this = "SymmetricKeyTaintTracking" }

    /** holds if the node is a key source. */
    override predicate isSource(DataFlow::Node src) { src instanceof KeySource }

    /** holds if the node is a symmetric encryption key sink. */
    override predicate isSink(DataFlow::Node sink) { sink instanceof SymmetricEncryptionKeySink }

    /** holds if the node is a key sanitizer. */
    override predicate isSanitizer(DataFlow::Node sanitizer) { sanitizer instanceof KeySanitizer }
  }
}
