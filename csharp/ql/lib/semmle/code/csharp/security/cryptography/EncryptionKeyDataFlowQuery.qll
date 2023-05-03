/**
 * This module has classes and data flow configuration for working with symmetric encryption keys data flow.
 */

import csharp
private import semmle.code.csharp.frameworks.system.security.cryptography.SymmetricAlgorithm

/** Array of type Byte */
deprecated class ByteArray extends ArrayType {
  ByteArray() { this.getElementType() instanceof ByteType }
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
    exists(SymmetricAlgorithm ag | this.asExpr() = ag.getKeyProperty().getAnAssignedValue())
  }

  override string getDescription() { result = "Key property assignment" }
}

/**
 * Symmetric Algorithm, CreateEncryptor method, rgbKey parameter
 */
class SymmetricEncryptionCreateEncryptorSink extends SymmetricEncryptionKeySink {
  SymmetricEncryptionCreateEncryptorSink() {
    exists(SymmetricAlgorithm ag, MethodCall mc | mc = ag.getASymmetricEncryptor() |
      this.asExpr() = mc.getArgumentForName("rgbKey")
    )
  }

  override string getDescription() { result = "Encryptor(rgbKey, IV)" }
}

/**
 * Symmetric Algorithm, CreateDecryptor method, rgbKey parameter
 */
class SymmetricEncryptionCreateDecryptorSink extends SymmetricEncryptionKeySink {
  SymmetricEncryptionCreateDecryptorSink() {
    exists(SymmetricAlgorithm ag, MethodCall mc | mc = ag.getASymmetricDecryptor() |
      this.asExpr() = mc.getArgumentForName("rgbKey")
    )
  }

  override string getDescription() { result = "Decryptor(rgbKey, IV)" }
}

/**
 * DEPRECATED: Use `SymmetricKey` instead.
 *
 * Symmetric Key Data Flow configuration.
 */
deprecated class SymmetricKeyTaintTrackingConfiguration extends TaintTracking::Configuration {
  SymmetricKeyTaintTrackingConfiguration() { this = "SymmetricKeyTaintTracking" }

  /** Holds if the node is a key source. */
  override predicate isSource(DataFlow::Node src) { src instanceof KeySource }

  /** Holds if the node is a symmetric encryption key sink. */
  override predicate isSink(DataFlow::Node sink) { sink instanceof SymmetricEncryptionKeySink }

  /** Holds if the node is a key sanitizer. */
  override predicate isSanitizer(DataFlow::Node sanitizer) { sanitizer instanceof KeySanitizer }
}

/**
 * Symmetric Key Data Flow configuration.
 */
private module SymmetricKeyConfig implements DataFlow::ConfigSig {
  /** Holds if the node is a key source. */
  predicate isSource(DataFlow::Node src) { src instanceof KeySource }

  /** Holds if the node is a symmetric encryption key sink. */
  predicate isSink(DataFlow::Node sink) { sink instanceof SymmetricEncryptionKeySink }

  /** Holds if the node is a key sanitizer. */
  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof KeySanitizer }
}

/**
 * Symmetric Key Data Flow configuration.
 */
module SymmetricKey = TaintTracking::Global<SymmetricKeyConfig>;
