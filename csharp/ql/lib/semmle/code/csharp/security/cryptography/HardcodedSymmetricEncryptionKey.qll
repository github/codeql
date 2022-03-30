/**
 * Provides a taint-tracking configuration for reasoning about hard-coded
 * symmetric encryption keys.
 */

import csharp

module HardcodedSymmetricEncryptionKey {
  private import semmle.code.csharp.frameworks.system.security.cryptography.SymmetricAlgorithm

  /** A data flow source for hard-coded symmetric encryption keys. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for hard-coded symmetric encryption keys. */
  abstract class Sink extends DataFlow::ExprNode {
    /** Gets a description of this sink. */
    abstract string getDescription();
  }

  /** A sanitizer for hard-coded symmetric encryption keys. */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  private class ByteArrayType extends ArrayType {
    ByteArrayType() { this.getElementType() instanceof ByteType }
  }

  private class ByteArrayLiteralSource extends Source {
    ByteArrayLiteralSource() {
      this.asExpr() =
        any(ArrayCreation ac |
          ac.getArrayType() instanceof ByteArrayType and
          ac.hasInitializer()
        )
    }
  }

  private class StringLiteralSource extends Source {
    StringLiteralSource() { this.asExpr() instanceof StringLiteral }
  }

  private class SymmetricEncryptionKeyPropertySink extends Sink {
    SymmetricEncryptionKeyPropertySink() {
      this.asExpr() = any(SymmetricAlgorithm sa).getKeyProperty().getAnAssignedValue()
    }

    override string getDescription() { result = "'Key' property assignment" }
  }

  private class SymmetricEncryptionCreateEncryptorSink extends Sink {
    SymmetricEncryptionCreateEncryptorSink() {
      exists(SymmetricAlgorithm ag, MethodCall mc | mc = ag.getASymmetricEncryptor() |
        this.asExpr() = mc.getArgumentForName("rgbKey")
      )
    }

    override string getDescription() { result = "Encryptor(rgbKey, IV)" }
  }

  private class SymmetricEncryptionCreateDecryptorSink extends Sink {
    SymmetricEncryptionCreateDecryptorSink() {
      exists(SymmetricAlgorithm ag, MethodCall mc | mc = ag.getASymmetricDecryptor() |
        this.asExpr() = mc.getArgumentForName("rgbKey")
      )
    }

    override string getDescription() { result = "Decryptor(rgbKey, IV)" }
  }

  private class CreateSymmetricKeySink extends Sink {
    CreateSymmetricKeySink() {
      exists(MethodCall mc, Method m |
        mc.getTarget() = m and
        m.hasQualifiedName("Windows.Security.Cryptography.Core.SymmetricKeyAlgorithmProvider",
          "CreateSymmetricKey") and
        this.asExpr() = mc.getArgumentForName("keyMaterial")
      )
    }

    override string getDescription() { result = "CreateSymmetricKey(IBuffer keyMaterial)" }
  }

  private class CryptographicBuffer extends Class {
    CryptographicBuffer() {
      this.hasQualifiedName("Windows.Security.Cryptography", "CryptographicBuffer")
    }
  }

  /**
   * A taint-tracking configuration for uncontrolled data in path expression vulnerabilities.
   */
  class TaintTrackingConfiguration extends TaintTracking::Configuration {
    TaintTrackingConfiguration() { this = "HardcodedSymmetricEncryptionKey" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

    /**
     * Since `CryptographicBuffer` uses native code inside, taint tracking doesn't pass through it.
     * Need to create an additional custom step.
     */
    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(MethodCall mc, CryptographicBuffer c |
        pred.asExpr() = mc.getAnArgument() and
        mc.getTarget() = c.getAMethod() and
        succ.asExpr() = mc
      )
    }
  }
}
